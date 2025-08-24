import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final bool showError;
  final VoidCallback onTap;

  const AppDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = date != null;
    final borderColor = hasValue ? AppColors.green500 : AppColors.borderUnselected;
    final iconColor = hasValue ? AppColors.status100 : AppColors.borderUnselected;
    final textColor = hasValue ? AppColors.status100 : AppColors.status100.withOpacity(0.25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption1Regular.copyWith(color: AppColors.status100),
        ),
        SizedBox(height: AppSpacing.spacing8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: AppDimensions.dateFieldHeight,
            width: AppDimensions.dateFieldWidth,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.w),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Row(
              children: [
                Assets.icons.icCalendar.svg(
                  width: AppDimensions.iconSize16,
                  height: AppDimensions.iconSize16,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                SizedBox(width: AppSpacing.spacing8),
                Text(
                    hasValue ? DateFormat('yyyy년 M월 d일').format(date!) : '$label을 선택하세요',
                    style: AppTypography.caption1Regular.copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(top: AppDimensions.paddingDateFieldErrorTop),
            child: Text(
              '$label을 선택해주세요',
              style: AppTypography.caption1Regular.copyWith(color: AppColors.red500),
            ),
          )
      ],
    );
  }
}