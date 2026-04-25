import 'package:flutter/material.dart';
import '../constants.dart';

class ProgressStep extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const ProgressStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: index ~/ 2 < currentStep
                  ? AppColors.primary
                  : Colors.white.withOpacity(0.2),
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final isActive = stepIndex <= currentStep;
        final isCompleted = stepIndex < currentStep;

        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.surface,
                border: Border.all(
                  color: isActive ? AppColors.primary : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
            if (stepIndex < labels.length) ...[
              const SizedBox(height: 4),
              Text(
                labels[stepIndex],
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? Colors.white : Colors.white54,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
