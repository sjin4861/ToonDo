import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppKakaoLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppKakaoLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(AppDimensions.signInButtonWidth, AppDimensions.signInButtonHeight),
        backgroundColor: Color(0xFFFDDC3F),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing16),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.imgKakao.image(
            width: AppDimensions.iconSize32,
            height: AppDimensions.iconSize32,
            fit: BoxFit.cover,
          ),
          SizedBox(width: AppSpacing.spacing12),
          Text(
            '카카오 계속하기',
            textAlign: TextAlign.center,
            style: AppTypography.h3Bold.copyWith(color: AppColors.status100),
          ),
        ],
      ),
    );
  }
}
