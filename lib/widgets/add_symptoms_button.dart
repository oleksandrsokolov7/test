import 'package:flutter/material.dart';
import 'package:my_period_tracker/screen/symptoms_screen.dart';

class AddSymptomsButton extends StatelessWidget {
  final Color phaseColor;
  final Function(List<String>, String) onSymptomsUpdate;

  const AddSymptomsButton({
    super.key,
    required this.phaseColor,
    required this.onSymptomsUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        child: OutlinedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SymptomsScreen(
                  phaseColor: phaseColor,
                ),
              ),
            );

            if (result != null && result is Map<String, dynamic>) {
              List<String> symptoms =
                  List<String>.from(result['symptoms'] ?? []);
              String notes = result['notes'] ?? '';
              onSymptomsUpdate(symptoms, notes);
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: phaseColor,
            side: BorderSide(color: phaseColor),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('+ ADD SYMPTOMS', style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}
