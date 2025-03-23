import 'package:flutter/material.dart';
import 'package:my_period_tracker/screen/cycle_utils.dart';

class PhaseCard extends StatelessWidget {
  final String currentPhase;
  final Color phaseColor;
  final bool isInPeriod;
  final bool isInFertileWindow;
  final int periodLengthDays;
  final DateTime today;
  final DateTime previousPeriodStartDate;
  final DateTime fertileWindowEnd;
  final int daysUntilNextPeriod;
  final int daysUntilOvulation;

  const PhaseCard({
    super.key,
    required this.currentPhase,
    required this.phaseColor,
    required this.isInPeriod,
    required this.isInFertileWindow,
    required this.periodLengthDays,
    required this.today,
    required this.previousPeriodStartDate,
    required this.fertileWindowEnd,
    required this.daysUntilNextPeriod,
    required this.daysUntilOvulation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: phaseColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentPhase,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: phaseColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                CycleUtils.getPhaseDescription(currentPhase),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              isInPeriod
                  ? _buildInfoRow('Period ends in',
                      '${periodLengthDays - today.difference(previousPeriodStartDate).inDays} days')
                  : isInFertileWindow
                      ? _buildInfoRow('Fertile window ends in',
                          '${fertileWindowEnd.difference(today).inDays + 1} days')
                      : _buildInfoRow(
                          'Next period begin in', '$daysUntilNextPeriod days'),
              const SizedBox(height: 8),
              _buildInfoRow(
                  'Next ovulation will start in', '$daysUntilOvulation days'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
