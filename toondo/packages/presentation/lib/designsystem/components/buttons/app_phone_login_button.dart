import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppPhoneLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppPhoneLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(AppDimensions.signInButtonWidth, AppDimensions.signInButtonHeight),
        backgroundColor: AppColors.green400,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.imgPhone.image(
            width: AppDimensions.iconSize32,
            height: AppDimensions.iconSize32,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Text(
            '번호로 가입하기',
            textAlign: TextAlign.center,
            style: AppTypography.h3Bold.copyWith(color: AppColors.status100),
          ),
        ],
      ),
    );
  }
}
