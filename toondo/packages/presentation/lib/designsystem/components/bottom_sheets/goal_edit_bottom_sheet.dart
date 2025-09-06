import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/utils/goal_utils.dart';

class GoalEditBottomSheet extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalEditBottomSheet({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      fixedHeight: AppDimensions.goalEditBottomSheetHeight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: AppSpacing.v32),
          _buildEditButton(),
          SizedBox(height: AppSpacing.v16),
          _buildDeleteButton(),
          SizedBox(height: AppSpacing.v44),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildGoalIconWithCircle(
          iconPath,
          size: AppDimensions.iconSize24,
          innerPadding: AppSpacing.a4,
          borderWidth: 1.2,
        ),
        SizedBox(width: AppSpacing.h8),
        Text(
          title,
          style: AppTypography.h1Bold.copyWith(
            color: AppColors.status100,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onEdit,
        icon: Icon(Icons.edit, size: AppDimensions.iconSize24, color: Colors.white),
        label: Text(
          '수정하기',
          style: AppTypography.h2Bold.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onDelete,
        icon: Icon(
          Icons.delete,
          size: AppDimensions.iconSize20,
          color: AppColors.green500,
        ),
        label: Text(
          '삭제하기',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h40, vertical: AppSpacing.v12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          side: const BorderSide(color: AppColors.green500),
        ),
      ),
    );
  }
}
