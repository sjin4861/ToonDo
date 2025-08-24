import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/utils/goal_utils.dart';

class TodoEditBottomSheet extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color iconBgColor;
  final bool isDaily;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onDelay;

  const TodoEditBottomSheet({
    super.key,
    required this.title,
    required this.iconPath,
    required this.iconBgColor,
    required this.isDaily,
    required this.onEdit,
    required this.onDelete,
    this.onDelay,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      fixedHeight: isDaily ?  AppDimensions.todoEditBottomSheetHeightDaily : AppDimensions.todoEditBottomSheetHeightDDay,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: AppSpacing.h32),
          _buildEditButton(),
          SizedBox(height: AppSpacing.h16),
          _buildDeleteButton(),
          if (isDaily) ...[
            SizedBox(height: AppSpacing.h16),
            _buildDelayButton(),
          ],
          SizedBox(height: AppSpacing.h44),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTodoIconWithCircle(
          iconPath,
          size: AppDimensions.iconSize24,
          innerPadding: AppSpacing.a4,
          borderWidth: 1.2,
          backgroundColor: iconBgColor,
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
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

  Widget _buildDelayButton() {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onDelay,
        icon: Icon(
          Icons.arrow_circle_right,
          size: AppDimensions.iconSize20,
          color: AppColors.green500,
        ),
        label: Text(
          '내일하기',
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
