import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AdBannerContent {
  final String appName;
  final String ctaLabel;
  final ImageProvider? image;

  const AdBannerContent({
    required this.appName,
    this.ctaLabel = 'install',
    this.image,
  });
}

/// 알약 모양의 인앱 광고 배너 (시안: onboarding-8.png 참고).
///
/// 실제 AdMob SDK 연동은 별도 작업으로 분리. 현 단계에서는 동일한 형태의
/// 정적 UI만 제공하므로, 추후 SDK 응답을 [AdBannerContent]에 매핑해 같은
/// 위젯을 재사용할 수 있다.
class AppAdBanner extends StatelessWidget {
  final AdBannerContent content;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AppAdBanner({
    super.key,
    required this.content,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h12,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: AppColors.borderUnselected),
      ),
      child: Row(
        children: [
          _buildImage(),
          SizedBox(width: AppSpacing.h12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.appName,
                  style: AppTypography.body2Bold.copyWith(
                    color: AppColors.status100,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _chip('Ad'),
                    SizedBox(width: AppSpacing.h4),
                    _chip(content.ctaLabel),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.h8),
          _circleIconButton(
            icon: Icons.play_arrow_rounded,
            onTap: onTap,
            semanticLabel: '광고 보기',
          ),
          SizedBox(width: AppSpacing.h4),
          _circleIconButton(
            icon: Icons.close_rounded,
            onTap: onDismiss,
            semanticLabel: '광고 닫기',
            iconColor: AppColors.status100_50,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final image = content.image;
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColors.borderUnselected,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: image == null
          ? Center(
              child: Text(
                'image',
                style: AppTypography.caption3Regular.copyWith(
                  color: AppColors.status100_50,
                ),
              ),
            )
          : Image(image: image, fit: BoxFit.cover),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.green100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Text(
        label,
        style: AppTypography.caption3Regular.copyWith(
          color: AppColors.green500,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    required String semanticLabel,
    Color iconColor = AppColors.green500,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onTap,
        radius: 20.r,
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }
}
