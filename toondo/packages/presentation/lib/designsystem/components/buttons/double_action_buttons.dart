import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class DoubleActionButtons extends StatelessWidget {
  final String backText;
  final String nextText;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool isNextEnabled;

  const DoubleActionButtons({
    super.key,
    required this.backText,
    required this.nextText,
    required this.onBack,
    required this.onNext,
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              backText,
              style: AppTypography.h3Bold.copyWith(
                color: AppColors.status100_50,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.spacing16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isNextEnabled ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(AppSpacing.spacing16),
            ),
            child: Text(
              nextText,
              style: AppTypography.h3Bold.copyWith(color: AppColors.status0),
            ),
          ),
        ),
      ],
    );
  }
}
