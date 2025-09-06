import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:provider/provider.dart';

class PasswordChangeBody extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const PasswordChangeBody({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AccountSettingViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v24),
        _buildTitle(),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          label: '현재 비밀번호',
          controller: currentPasswordController,
          hintText: '기존 비밀번호 입력',
          obscureText: true,
          showToggleVisibility: true,
          errorText: viewModel.currentPasswordError,
        ),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          label: '새 비밀번호',
          controller: newPasswordController,
          hintText: '새 비밀번호 입력',
          obscureText: true,
          showToggleVisibility: true,
          errorText: viewModel.newPasswordError,
        ),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          label: '새 비밀번호 확인',
          controller: confirmPasswordController,
          hintText: '새 비밀번호 재입력',
          obscureText: true,
          showToggleVisibility: true,
          errorText: viewModel.confirmPasswordError,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      '현재 비밀번호와 변경할 비밀번호를 입력해주세요',
      style: AppTypography.h2Bold.copyWith(
        color: AppColors.green500,
        height: 1.5,
      ),
    );
  }
}
