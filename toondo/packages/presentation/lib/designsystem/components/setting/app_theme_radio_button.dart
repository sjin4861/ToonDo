import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppThemeRadioButton extends StatelessWidget {
  final ThemeModeType type;
  final bool isSelected;
  final VoidCallback onTap;

  const AppThemeRadioButton({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  bool get isDarkMode => type == ThemeModeType.dark;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected ? AppColors.green500 : AppColors.borderUnselected;

    final faceColor =
        isDarkMode ? const Color(0xA8FFFFFF) : const Color(0xFFBEBEBE);

    final backgroundColor = isDarkMode ? const Color(0xCC111111) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 145,
            height: 96,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
              child: Assets.icons.icFace0.svg(
                width: 50,
                height: 50,
                colorFilter: ColorFilter.mode(faceColor, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacing8),
          Text(
            type.label,
            style: AppTypography.body1Regular.copyWith(
              color: AppColors.status100,
            ),
          ),
          SizedBox(height: AppSpacing.spacing8),
          Container(
            width: AppDimensions.radioSize,
            height: AppDimensions.radioSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child:
                isSelected
                    ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: borderColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    : null,
          ),
        ],
      ),
    );
  }
}
