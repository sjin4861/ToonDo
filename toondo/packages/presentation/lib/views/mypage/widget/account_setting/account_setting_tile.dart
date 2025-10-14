import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/components/app_ink_well.dart';

class AccountSettingTile extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const AccountSettingTile({super.key, required this.label, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.v14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.h3Regular.copyWith(
                color: AppColors.status100,
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value!,
                    style: AppTypography.h3Regular.copyWith(
                      color: const Color(0xFF858584),
                    ),
                  ),
                SizedBox(width: AppSpacing.h24),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppDimensions.iconSize16,
                  color: const Color(0xFFD9D9D9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
