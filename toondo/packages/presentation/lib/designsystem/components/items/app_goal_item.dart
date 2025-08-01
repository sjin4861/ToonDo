import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppGoalItem extends StatelessWidget {
  final Key dismissKey;
  final String title;
  final String? iconPath;
  final String? subTitle;
  final bool isChecked;
  final Color backgroundColor;
  final ValueChanged<bool>? onCheckedChanged;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeLeft;

  const AppGoalItem({
    super.key,
    required this.dismissKey,
    required this.title,
    this.iconPath,
    this.subTitle,
    this.isChecked = false,
    this.backgroundColor = Colors.transparent,
    this.onCheckedChanged,
    this.onTap,
    this.onSwipeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissKey!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onSwipeLeft?.call(),
      background: Container(
        height: AppDimensions.goalItemHeight,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing12),
        color: AppColors.red600,
        child: const Icon(
          Icons.delete,
          color: AppColors.status0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.goalItemBorderRadius),
          child: Container(
            height: AppDimensions.goalItemHeight,
            padding: EdgeInsets.fromLTRB(AppSpacing.spacing12, AppSpacing.spacing12, AppSpacing.spacing16, AppSpacing.spacing12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.goalItemBorderRadius),
              border: Border.all(
                color: isChecked
                    ? AppColors.itemCompletedBorder
                    : AppColors.green300,
                width: AppDimensions.goalItemBorderWidth,
              ),
              color: isChecked
                  ? AppColors.itemCompletedBackground
                  : backgroundColor,
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(child: _buildTitleWithOptionalSubtitle()),
                const SizedBox(width: AppSpacing.spacing12),
                _buildCheckbox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final Color borderColor = isChecked
        ? AppColors.itemCompletedBorder.withOpacity(0.5)
        : AppColors.green300;

    return Container(
      width: AppDimensions.goalIconSize,
      height: AppDimensions.goalIconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: borderColor,
          width: AppDimensions.goalItemBorderWidth,
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.goalIconInnerPadding),
      child: SvgPicture.asset(
        iconPath ?? Assets.icons.icHelpCircle.path,
        width: AppDimensions.goalIconSize,
        height: AppDimensions.goalIconSize,
        colorFilter: ColorFilter.mode(
          isChecked
              ? AppColors.status100_50
              : AppColors.status100,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildTitleWithOptionalSubtitle() {
    if (subTitle == null || subTitle!.isEmpty) {
      return Text(
        title,
        style: AppTypography.body2Bold.copyWith(
          color: isChecked
              ? AppColors.status100.withOpacity(0.3)
              : AppColors.status100,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTypography.body2Bold.copyWith(
            color: isChecked
                ? AppColors.status100.withOpacity(0.3)
                : AppColors.status100,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          subTitle!,
          style: AppTypography.caption3Regular.copyWith(
            color: isChecked
                ? AppColors.status100.withOpacity(0.3)
                : AppColors.status100.withOpacity(0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return SizedBox(
      width: AppDimensions.checkboxSize,
      height: AppDimensions.checkboxSize,
      child: Checkbox(
        value: isChecked,
        onChanged: (value) {
          if (value != null) onCheckedChanged?.call(value);
        },
        side: const BorderSide(
          color: AppColors.borderLight,
          width: AppDimensions.checkboxBorderWidth,
        ),
        activeColor: AppColors.itemCompletedBorder,
        checkColor: AppColors.status0,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
