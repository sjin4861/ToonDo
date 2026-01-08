import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class LoginBody extends StatelessWidget {
  final String? passedLoginId;

  const LoginBody({super.key, this.passedLoginId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v64),
        Text(
          '다시 만나서 반가워요! 👋🏻',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(height: AppSpacing.v8),
        Text(
          '비밀번호를 입력하고 로그인하세요.',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
        SizedBox(height: AppSpacing.v32),
        AppInputField(
          label: '아이디',
          controller: viewModel.loginIdController,
          hintText: passedLoginId != null ? null : '아이디를 입력하세요',
          isEnabled: passedLoginId == null,
          onChanged: viewModel.onLoginIdChanged,
          errorText: viewModel.loginIdError,
        ),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          label: '비밀번호',
          controller: viewModel.passwordController,
          obscureText: true,
          showToggleVisibility: true,
          onToggleVisibility: viewModel.togglePasswordVisibility,
          onChanged: viewModel.setPassword,
          errorText: viewModel.passwordError,
        ),
        if (viewModel.loginError != null) ...[
          SizedBox(height: AppSpacing.v12),
          Text(
            viewModel.loginError!,
            style: AppTypography.body2Regular.copyWith(color: AppColors.red700),
          ),
        ],
        SizedBox(height: AppSpacing.v32),
      ],
    );
  }
}
