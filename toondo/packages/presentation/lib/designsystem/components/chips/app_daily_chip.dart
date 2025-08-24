import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final double h = AppDimensions.chipHeight;
    final double w = AppDimensions.chipWidth;
    final double r = AppDimensions.chipBorderRadius;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.green500, width: 1.w),
          borderRadius: BorderRadius.circular(r),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SideChip(
              label: '디데이',
              isSelected: isLeftSelected,
              onTap: () => onSelectedChanged(true),
              radius: BorderRadius.only(
                topLeft: Radius.circular(r),
                bottomLeft: Radius.circular(r),
              ),
              width: w,
              height: h,
            ),
            _SideChip(
              label: '데일리',
              isSelected: !isLeftSelected,
              onTap: () => onSelectedChanged(false),
              radius: BorderRadius.only(
                topRight: Radius.circular(r),
                bottomRight: Radius.circular(r),
              ),
              width: w,
              height: h,
            ),
          ],
        ),
      ),
    );
  }
}

class _SideChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BorderRadius radius;
  final double width;
  final double height;

  const _SideChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.radius,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isSelected ? AppColors.green500 : Colors.transparent;
    final Color textColor = isSelected ? AppColors.status0 : AppColors.status100;

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: AppColors.green500, width: 0.2.w),
          borderRadius: radius,
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: (isSelected ? AppTypography.caption1Bold : AppTypography.caption1Regular)
                .copyWith(color: textColor),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
