import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppGoogleLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppGoogleLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(AppDimensions.signInButtonWidth, AppDimensions.signInButtonHeight),
        backgroundColor: AppColors.status0,
        side: BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.imgGoogle.image(
            width: AppDimensions.iconSize32,
            height: AppDimensions.iconSize32,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Text(
            '구글로 계속하기',
            textAlign: TextAlign.center,
            style: AppTypography.h3Bold.copyWith(color: AppColors.status100),
          ),
        ],
      ),
    );
  }
}
