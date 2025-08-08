import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/utils/goal_utils.dart';

class GoalCompleteBottomSheet extends StatelessWidget {
  final String goalTitle;
  final String iconPath;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onConfirm;

  const GoalCompleteBottomSheet({
    super.key,
    required this.goalTitle,
    required this.iconPath,
    required this.startDate,
    required this.endDate,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      fixedHeight: AppDimensions.goalCompleteBottomSheetHeight,
      isScrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '목표 설정을 완료했어요!',
            style: AppTypography.h1Bold.copyWith(
              color: AppColors.status100,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing24),
          buildGoalIconWithCircle(
            iconPath,
            size: AppDimensions.iconSize50,
            borderWidth: 1,
            innerPadding: AppSpacing.spacing4,
            borderColor: AppColors.green500,
          ),
          const SizedBox(height: AppSpacing.spacing18),
          _buildGoalInfo(),
          const SizedBox(height: AppSpacing.spacing32),
          _buildConfirmButton(),
          const SizedBox(height: AppSpacing.spacing44),
        ],
      ),
    );
  }

  Widget _buildGoalInfo() {
    return Column(
      children: [
        Text(
          goalTitle,
          style: AppTypography.h2Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        Text(
          '${_formatDate(startDate)} ~ ${_formatDate(endDate)}',
          style: AppTypography.caption3Regular.copyWith(
            color: AppColors.status100_50,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing40, vertical: AppSpacing.spacing12),
        ),
        child: Text(
          '확인하기',
          style: AppTypography.h2Bold.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year % 100}.${_pad(date.month)}.${_pad(date.day)}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}
