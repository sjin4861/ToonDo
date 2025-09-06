import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:provider/provider.dart';

class SignupStep2Body extends StatelessWidget {
  const SignupStep2Body({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v64),
        _buildHeaderText(),
        SizedBox(height: AppSpacing.v56),
        AppInputField(
          label: '비밀번호',
          controller: viewModel.passwordTextController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          obscureText: viewModel.isPasswordObscured,
          showToggleVisibility: true,
          onToggleVisibility: () => viewModel.togglePasswordVisibility(),
          errorText: viewModel.passwordError,
          onChanged: (value) => viewModel.setPassword(value),
        ),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          label: '비밀번호 확인',
          controller: viewModel.confirmPasswordTextController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          obscureText: viewModel.isConfirmPasswordObscured,
          showToggleVisibility: true,
          onToggleVisibility: () => viewModel.toggleConfirmPasswordVisibility(),
          errorText: viewModel.confirmPasswordError,
          onChanged: (value) => viewModel.setConfirmPassword(value),
        ),
        Spacer()
      ],
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '툰두와 처음 만나셨네요! 👋🏻',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(height: AppSpacing.v8),
        Text(
          '영문과 숫자를 조합한 8~20자의 비밀번호를 만들어주세요.',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
      ],
    );
  }
}
