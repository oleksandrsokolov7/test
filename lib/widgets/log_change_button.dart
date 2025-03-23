import 'package:flutter/material.dart';
import 'package:my_period_tracker/screen/dashboard_dialogs.dart';

class LogChangeButton extends StatelessWidget {
  final Color phaseColor;
  final DateTime previousPeriodStartDate;
  final Function(DateTime) onPeriodDateUpdate;

  const LogChangeButton({
    super.key,
    required this.phaseColor,
    required this.previousPeriodStartDate,
    required this.onPeriodDateUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        child: ElevatedButton(
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Update Period Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading:
                              Icon(Icons.calendar_today, color: phaseColor),
                          title: const Text('Log period start date'),
                          subtitle: const Text('Set when your period started'),
                          onTap: () async {
                            Navigator.pop(context);

                            final DateTime? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DashboardDialogs.buildPeriodLogDialog(
                                    context,
                                    previousPeriodStartDate,
                                    phaseColor);
                              },
                            );
                            if (result != null) {
                              onPeriodDateUpdate(result);
                            }
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.check_circle_outline,
                              color: phaseColor),
                          title: const Text('My period started today'),
                          subtitle:
                              const Text('Set today as your period start'),
                          onTap: () {
                            Navigator.pop(context);
                            onPeriodDateUpdate(DateTime.now());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: phaseColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Log/Change', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
