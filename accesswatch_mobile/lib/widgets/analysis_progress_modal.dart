import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'demo_badge.dart';

class AnalysisProgressModal extends StatefulWidget {
  final VoidCallback onComplete;

  const AnalysisProgressModal({super.key, required this.onComplete});

  @override
  State<AnalysisProgressModal> createState() => _AnalysisProgressModalState();
}

class _AnalysisProgressModalState extends State<AnalysisProgressModal> {
  int _currentStep = 0;
  Timer? _timer;

  final List<String> _steps = [
    '01  Loading radar observation',
    '02  Detecting flood extent',
    '03  Estimating water depth',
    '04  Classifying road water levels',
    '05  Checking roads & services',
    '06  Finding isolated pockets',
    '07  Ranking response priority',
    '08  Generating mission cards',
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_currentStep < _steps.length - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.pop(context);
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _steps.length;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SAR ANALYSIS PIPELINE',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                DemoBadge(compact: true),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 20),

            // Steps List
            Column(
              children: List.generate(_steps.length, (index) {
                final isDone = index < _currentStep;
                final isCurrent = index == _currentStep;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : isCurrent
                                ? Icons.sync_rounded
                                : Icons.radio_button_unchecked_rounded,
                        size: 18,
                        color: isDone
                            ? AppColors.accent
                            : isCurrent
                                ? AppColors.warning
                                : AppColors.textMuted.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _steps[index],
                          style: TextStyle(
                            color: isDone || isCurrent ? Colors.white : AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
