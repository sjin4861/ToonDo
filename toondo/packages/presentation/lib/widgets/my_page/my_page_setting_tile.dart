import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class MyPageSettingTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? leadingIcon;
  final VoidCallback? onTap;

  const MyPageSettingTile({
    super.key,
    required this.title,
    this.trailing,
    this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: AppDimensions.tileHeight,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.spacing14,
          ),
          color: Colors.transparent,
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: AppSpacing.spacing8),
              ],
              Text(
                title,
                style: AppTypography.h3Regular.copyWith(
                  color: AppColors.status100,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

