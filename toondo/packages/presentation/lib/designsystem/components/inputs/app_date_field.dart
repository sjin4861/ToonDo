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
  final bool enabled;

  const AppDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
    this.showError = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = date != null;
    final disabledFill = AppColors.status100.withOpacity(0.08);
    final borderColor =
        hasValue ? AppColors.green500 : AppColors.borderUnselected;
    final iconColor =
        hasValue ? AppColors.status100 : AppColors.borderUnselected;
    final textColor =
        hasValue ? AppColors.status100 : AppColors.status100.withOpacity(0.25);
    final baseStyle = AppTypography.caption1Regular;
    final errorStyle = baseStyle.copyWith(color: AppColors.red500);

    final fontSize = errorStyle.fontSize ?? 12;
    final lineHeight = (errorStyle.height ?? 1.2) * fontSize;
    final errorSlotHeight =
    AppDimensions.paddingDateFieldErrorTop + lineHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            height: AppDimensions.dateFieldHeight,
            width: AppDimensions.dateFieldWidth,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.h12),
            decoration: BoxDecoration(
              color: enabled ? Colors.transparent : disabledFill,
              border: Border.all(color: borderColor, width: 1.w),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            foregroundDecoration: !enabled
                ? BoxDecoration(
              color: Colors.transparent,
            )
                : null,
            child: Row(
              children: [
                Assets.icons.icCalendar.svg(
                  width: AppDimensions.iconSize16,
                  height: AppDimensions.iconSize16,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                SizedBox(width: AppSpacing.h8),
                Text(
                  hasValue
                      ? DateFormat('yyyy년 M월 d일').format(date!)
                      : '$label을 선택하세요',
                  style: AppTypography.caption1Regular.copyWith(
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: errorSlotHeight,
          child: (showError && enabled)
              ? Padding(
            padding: EdgeInsets.only(top: AppDimensions.paddingDateFieldErrorTop),
            child: Text(
              '$label을 선택해주세요',
              style: AppTypography.caption1Regular.copyWith(color: AppColors.red500),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
