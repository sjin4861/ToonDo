import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

enum AppButtonSize { small, medium, large }
enum AppButtonType { filled, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppButtonType type;
  final bool isEnabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.type = AppButtonType.filled,
    this.isEnabled = true,
  });

  double _heightBySize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.buttonHeight;
      case AppButtonSize.medium:
        return AppDimensions.buttonHeight;
      case AppButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  double _widthBySize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.buttonWidthSmall;
      case AppButtonSize.medium:
        return AppDimensions.buttonWidthMedium;
      case AppButtonSize.large:
        return AppDimensions.buttonWidthLarge;
    }
  }

  TextStyle _textStyleBySize() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.h3Bold;
      case AppButtonSize.medium:
        return AppTypography.h3Bold;
      case AppButtonSize.large:
        return AppTypography.h2Bold;
    }
  }

  Color _backgroundColor() {
    if (!isEnabled) return AppColors.buttonDisabledBackground;
    return type == AppButtonType.filled ? AppColors.green500 : Colors.transparent;
  }

  Color _textColor() {
    if (!isEnabled) return AppColors.buttonDisabledText;
    return type == AppButtonType.filled ? Colors.white : AppColors.green500;
  }

  BorderSide _borderSide() {
    if (!isEnabled) return BorderSide(color: AppColors.buttonDisabledBorder);
    return type == AppButtonType.outlined
        ? BorderSide(color: AppColors.green500)
        : BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          fixedSize: Size(_widthBySize(), _heightBySize()),
          backgroundColor: _backgroundColor(),
          side: _borderSide(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
        ),

        child: Text(
          label,
          style: _textStyleBySize().copyWith(color: _textColor()),
        ),
    );
  }
}
