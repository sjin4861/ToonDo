import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/help_guide/help_guide_viewmodel.dart';
import 'package:presentation/widgets/my_page/my_page_setting_tile.dart';
import 'package:provider/provider.dart';

class HelpGuideBody extends StatelessWidget {
  const HelpGuideBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HelpGuideViewModel>();
    final trailingIcon = const Icon(
      Icons.arrow_forward_ios,
      size: AppDimensions.iconSize16,
      color: Color(0xFFD9D9D9),
    );

    return Column(
      children: [
        SizedBox(height: AppSpacing.spacing24),
        MyPageSettingTile(
          title: '앱 버전',
          trailing: Text(
            vm.appVersion,
            style: AppTypography.h3Regular.copyWith(color: AppColors.status100),
          ),
        ),
        MyPageSettingTile(
          title: '이용약관',
          // icon: Icons.arrow_forward_ios,
          trailing: trailingIcon,
          onTap: vm.openTerms,
        ),
        MyPageSettingTile(
          title: '앱 리뷰 남기기',
          // icon: Icons.arrow_forward_ios,
          trailing: trailingIcon,
          onTap: vm.openAppReview,
        ),
        MyPageSettingTile(
          title: '개인정보 처리방침',
          // icon: Icons.arrow_forward_ios,
          trailing: trailingIcon,
          onTap: vm.openPrivacyPolicy,
        ),
      ],
    );
  }
}
