import 'package:flutter/material.dart';

class PredictedSymptomsSection extends StatelessWidget {
  final String currentPhase;
  final Color phaseColor;

  const PredictedSymptomsSection({
    super.key,
    required this.currentPhase,
    required this.phaseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predicted Symptoms for $currentPhase Phase',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: phaseColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Based on your cycle, you might experience the following symptoms:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '• Mood swings\n• Cramps\n• Fatigue\n• Bloating',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
