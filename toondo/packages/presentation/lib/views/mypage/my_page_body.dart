import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/mypage/widget/my_page_profile_section.dart';
import 'package:presentation/views/mypage/widget/my_page_setting_section.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.spacing32),
            const MyPageProfileSection(),
            SizedBox(height: AppSpacing.spacing24),
            const Divider(color: AppColors.myPageBorder, height: 1),
            SizedBox(height: AppSpacing.spacing32),
            const MyPageSettingSection(),
          ],
    );
  }
}
