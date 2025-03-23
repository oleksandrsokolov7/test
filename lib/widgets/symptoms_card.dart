import 'package:flutter/material.dart';

class SymptomsCard extends StatelessWidget {
  final List<String> loggedSymptoms;
  final String? symptomNotes;
  final Color phaseColor;

  const SymptomsCard({
    super.key,
    required this.loggedSymptoms,
    this.symptomNotes,
    required this.phaseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_information,
                    color: phaseColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your Logged Symptoms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: phaseColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: loggedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom),
                    backgroundColor: phaseColor.withAlpha(51),
                    side: BorderSide(color: phaseColor.withAlpha(128)),
                  );
                }).toList(),
              ),
              if (symptomNotes != null && symptomNotes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  symptomNotes!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
