import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/widgets/my_page/display_setting/theme_mode_option_group.dart';

class DisplaySettingBody extends StatelessWidget {
  const DisplaySettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.spacing24),
        _buildDisplaySettingTitle(),
        SizedBox(height: AppSpacing.spacing16),
        ThemeModeOptionGroup(),
      ],
    );
  }

  Widget _buildDisplaySettingTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing14),
      child: Text(
        '다크모드 설정',
        style: AppTypography.body1SemiBold.copyWith(
          color: AppColors.status100
        ),
      ),
    );
  }
}
