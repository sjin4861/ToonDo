import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:provider/provider.dart';

class SignupStep1Body extends StatelessWidget {
  const SignupStep1Body({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.spacing64),
        _buildHeaderText(),
        const SizedBox(height: AppSpacing.spacing56),
        AppInputField(
          label: '아이디',
          controller: viewModel.loginIdTextController,
          hintText: '자신만의 아이디를 입력해주세요!',
          errorText: viewModel.loginIdError,
          onChanged: (value) => viewModel.setLoginId(value),
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
          '아이디를 설정해주세요',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(height: AppSpacing.spacing8),
        Text(
          '아이디를 입력하여 가입하세요.',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
      ],
    );
  }
}
