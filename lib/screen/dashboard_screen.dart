import 'package:flutter/material.dart';

import 'package:my_period_tracker/widgets/phase_card.dart';
import 'package:my_period_tracker/widgets/symptoms_card.dart';
import 'package:my_period_tracker/widgets/log_change_button.dart';
import 'package:my_period_tracker/widgets/add_symptoms_button.dart';
import 'package:my_period_tracker/widgets/account_options.dart';
import 'package:my_period_tracker/widgets/predicted_symptoms_section.dart';
import 'calendar_view_screen.dart';
import 'cycle_progress_widget.dart';
import 'cycle_utils.dart';

class DashboardScreen extends StatefulWidget {
  final String? name;
  final String? email;
  final String periodLength;
  final String cycleLength;
  final DateTime dateOfBirth;
  final DateTime lastPeriodDate;
  final List<String>? loggedSymptoms;
  final String? symptomNotes;

  const DashboardScreen({
    super.key,
    this.name,
    this.email,
    required this.periodLength,
    required this.cycleLength,
    required this.dateOfBirth,
    required this.lastPeriodDate,
    this.loggedSymptoms,
    this.symptomNotes,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  void _handleSymptomsUpdate(List<String> newSymptoms, String? newNotes) {
    setState(() {
      _loggedSymptoms = newSymptoms;
      _symptomNotes = newNotes;
    });
  }

  int _selectedIndex = 1;
  bool _showCalendar = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String>? _loggedSymptoms;
  String? _symptomNotes;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();

    _loggedSymptoms = widget.loggedSymptoms;
    _symptomNotes = widget.symptomNotes;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int periodLengthDays =
        int.tryParse(widget.periodLength.split(' ').first) ?? 5;
    final int cycleLengthDays =
        int.tryParse(widget.cycleLength.split(' ').first) ?? 28;

    final DateTime today = DateTime.now();

    DateTime nextPeriodStartDate = widget.lastPeriodDate;
    while (nextPeriodStartDate.isBefore(today)) {
      nextPeriodStartDate =
          nextPeriodStartDate.add(Duration(days: cycleLengthDays));
    }

    DateTime previousPeriodStartDate = widget.lastPeriodDate;
    while (previousPeriodStartDate.isAfter(today) ||
        previousPeriodStartDate == today) {
      previousPeriodStartDate =
          previousPeriodStartDate.subtract(Duration(days: cycleLengthDays));
    }

    final DateTime ovulationDate =
        nextPeriodStartDate.subtract(const Duration(days: 14));
    final DateTime fertileWindowStart =
        ovulationDate.subtract(const Duration(days: 5));
    final DateTime fertileWindowEnd = ovulationDate;

    final int daysUntilNextPeriod =
        nextPeriodStartDate.difference(today).inDays;
    final int daysUntilOvulation = ovulationDate.difference(today).inDays;

    final bool isInPeriod =
        today.difference(previousPeriodStartDate).inDays < periodLengthDays;

    final bool isInFertileWindow =
        today.isAfter(fertileWindowStart.subtract(const Duration(days: 1))) &&
            today.isBefore(fertileWindowEnd.add(const Duration(days: 1)));

    final int cycleDay = today.difference(previousPeriodStartDate).inDays + 1;

    final phaseData = CycleUtils.calculateCyclePhase(
      cycleDay: cycleDay,
      isInPeriod: isInPeriod,
      isInFertileWindow: isInFertileWindow,
      daysUntilOvulation: daysUntilOvulation,
      daysUntilNextPeriod: daysUntilNextPeriod,
    );

    final String currentPhase = phaseData['phase'];
    final Color phaseColor = phaseData['color'];

    return Scaffold(
      body: SafeArea(
        child: _showCalendar
            ? CalendarView(
                cycleLengthDays: cycleLengthDays,
                periodLengthDays: periodLengthDays,
                lastPeriodDate: widget.lastPeriodDate,
                onPeriodDateChanged: (newDate) {
                  _handlePeriodDateUpdate(newDate);
                },
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${today.day} ${CycleUtils.getMonthName(today.month)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Cycle Day $cycleDay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: phaseColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CycleProgressWidget(
                              cycleLength: cycleLengthDays,
                              periodLength: periodLengthDays,
                              currentCycleDay: cycleDay,
                              animation: _animation.value,
                            ),
                          );
                        }),
                    const SizedBox(height: 20),
                    PhaseCard(
                      currentPhase: currentPhase,
                      phaseColor: phaseColor,
                      isInPeriod: isInPeriod,
                      isInFertileWindow: isInFertileWindow,
                      periodLengthDays: periodLengthDays,
                      today: today,
                      previousPeriodStartDate: previousPeriodStartDate,
                      fertileWindowEnd: fertileWindowEnd,
                      daysUntilNextPeriod: daysUntilNextPeriod,
                      daysUntilOvulation: daysUntilOvulation,
                    ),
                    if (_loggedSymptoms != null && _loggedSymptoms!.isNotEmpty)
                      SymptomsCard(
                        loggedSymptoms: _loggedSymptoms!,
                        symptomNotes: _symptomNotes,
                        phaseColor: phaseColor,
                      ),
                    const SizedBox(height: 20),
                    LogChangeButton(
                      phaseColor: phaseColor,
                      previousPeriodStartDate: previousPeriodStartDate,
                      onPeriodDateUpdate: _handlePeriodDateUpdate,
                    ),
                    if (isInPeriod)
                      AddSymptomsButton(
                        phaseColor: phaseColor,
                        onSymptomsUpdate: _handleSymptomsUpdate,
                      ),
                    if (!isInPeriod &&
                        (_loggedSymptoms == null || _loggedSymptoms!.isEmpty))
                      PredictedSymptomsSection(
                        currentPhase: currentPhase,
                        phaseColor: phaseColor,
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _showCalendar = true;
            } else if (index == 1) {
              _showCalendar = false;
            } else if (index == 2) {
              showAccountOptions(
                context,
                widget.name,
                widget.email,
                widget.periodLength,
                widget.cycleLength,
                widget.dateOfBirth,
                widget.lastPeriodDate,
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  void _handlePeriodDateUpdate(DateTime newPeriodDate) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Period start date updated'),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          name: widget.name,
          email: widget.email,
          periodLength: widget.periodLength,
          cycleLength: widget.cycleLength,
          dateOfBirth: widget.dateOfBirth,
          lastPeriodDate: newPeriodDate,
          loggedSymptoms: _loggedSymptoms,
          symptomNotes: _symptomNotes,
        ),
      ),
    );
  }
}
