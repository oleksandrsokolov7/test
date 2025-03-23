import 'package:flutter/material.dart';
import 'registration_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  String _periodLength = '';
  String _cycleLength = '';
  DateTime _dateOfBirth = DateTime.now();
  DateTime _lastPeriodStartDate = DateTime.now(); // Add last period start date

  // Widget to create number selection buttons
  Widget _buildNumberSelector(
      int min, int max, String unit, bool isPeriodLength) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: max - min + 1,
        itemBuilder: (context, index) {
          final number = min + index;
          final value = '$number $unit';
          final isSelected =
              isPeriodLength ? _periodLength == value : _cycleLength == value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isPeriodLength) {
                    _periodLength = value;
                  } else {
                    _cycleLength = value;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? Theme.of(context).primaryColor : null,
                foregroundColor: isSelected ? Colors.white : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(60, 50),
              ),
              child: Text('$number', style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Questions')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep++);
          } else {
            // Save data and navigate to Registration Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationScreen(
                  periodLength: _periodLength,
                  cycleLength: _cycleLength,
                  dateOfBirth: _dateOfBirth,
                  lastPeriodStartDate:
                      _lastPeriodStartDate, // Pass the last period start date
                ),
              ),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('What is your average period length?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select number of days:',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 9),
                _buildNumberSelector(1, 9, 'days', true),
                const SizedBox(height: 9),
                if (_periodLength.isNotEmpty)
                  Text('Selected: $_periodLength',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Step(
            title: const Text('What is your average cycle length?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select number of days:',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 9),
                _buildNumberSelector(21, 35, 'days', false),
                const SizedBox(height: 9),
                if (_cycleLength.isNotEmpty)
                  Text('Selected: $_cycleLength',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Step(
            title: const Text('Enter your date of birth'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(
                          days: 365 * 20)), // Default to 20 years ago
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _dateOfBirth = date);
                  },
                  child: const Text('Select Date'),
                ),
                const SizedBox(height: 9),
                Text(
                  'Selected date: ${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('When did your last period start?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(
                          days: 365 * 2)), // Allow selection up to 2 years ago
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _lastPeriodStartDate = date);
                    }
                  },
                  child: const Text('Select Date'),
                ),
                const SizedBox(height: 9),
                Text(
                  'Selected date: ${_lastPeriodStartDate.day}/${_lastPeriodStartDate.month}/${_lastPeriodStartDate.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
