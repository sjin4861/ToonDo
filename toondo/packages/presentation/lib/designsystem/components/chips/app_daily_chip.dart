import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppDailyChip extends StatelessWidget {
  final bool isLeftSelected;
  final ValueChanged<bool> onSelectedChanged;

  const AppDailyChip({
    super.key,
    required this.isLeftSelected,
    required this.onSelectedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.chipHeight,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green500),
        borderRadius: BorderRadius.circular(AppDimensions.chipBorderRadius),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSideChip(
            label: '디데이',
            isSelected: isLeftSelected,
            onTap: () => onSelectedChanged(true),
            isLeft: true,
          ),
          _buildSideChip(
            label: '데일리',
            isSelected: !isLeftSelected,
            onTap: () => onSelectedChanged(false),
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSideChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.chipHeight,
        width: AppDimensions.chipWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green500 : Colors.transparent,
          border: Border.all(color: AppColors.green500, width: 0.2),
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(AppDimensions.chipBorderRadius) : Radius.zero,
            bottomLeft: isLeft ? const Radius.circular(AppDimensions.chipBorderRadius) : Radius.zero,
            topRight: isLeft ? Radius.zero : const Radius.circular(AppDimensions.chipBorderRadius),
            bottomRight: isLeft ? Radius.zero : const Radius.circular(AppDimensions.chipBorderRadius),
          ),
        ),
        child: Text(
          label,
          style: (isSelected ? AppTypography.caption1Bold : AppTypography.caption1Regular).copyWith(
            color: isSelected ? AppColors.status0 : AppColors.status100,
          ),
        ),
      ),
    );
  }

}

