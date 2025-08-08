import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:provider/provider.dart';

class NicknameChangeBody extends StatelessWidget {
  final TextEditingController controller;

  const NicknameChangeBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AccountSettingViewModel>();
    final currentNickname = vm.userUiModel?.displayName ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.spacing24),
        _buildTitle(),
        const SizedBox(height: AppSpacing.spacing24),
        AppInputField(
          label: '현재 닉네임',
          controller: TextEditingController(text: currentNickname),
          isEnabled: false,
        ),
        const SizedBox(height: AppSpacing.spacing24),
        AppInputField(
          label: '새 닉네임',
          hintText: '2~10자의 닉네임 입력',
          controller: controller,
          errorText: vm.nicknameErrorMessage,
          onChanged: (_) {
            if (vm.nicknameErrorMessage != null) {
              vm.updateNickname('');
            }
          },
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
        '닉네임을 입력해주세요',
        style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
    );
  }
}
