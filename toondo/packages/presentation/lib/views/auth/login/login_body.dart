import 'package:flutter/material.dart';
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '다시 만나서 반가워요! 👋🏻',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF78B545),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.spacing8),
            Text(
              '비밀번호를 입력하고 로그인하세요.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xBF1C1D1B),
              ),
            ),
            SizedBox(height: AppSpacing.spacing32),
            AppInputField(
              label: '아이디',
              controller: viewModel.loginIdController,
              hintText: passedLoginId != null ? null : '아이디를 입력하세요',
              isEnabled: passedLoginId == null,
              errorText: (viewModel.loginError != null &&
                  viewModel.loginIdController.text.trim().isEmpty)
                  ? viewModel.loginError
                  : null,
            ),
            SizedBox(height: AppSpacing.spacing24),
            AppInputField(
              label: '비밀번호',
              controller: viewModel.passwordController,
              obscureText: true,
              showToggleVisibility: true,
              onToggleVisibility: viewModel.togglePasswordVisibility,
              onChanged: viewModel.setPassword,
              errorText: viewModel.passwordError,
            ),
            SizedBox(height: AppSpacing.spacing32),
          ],
        ),
      ),
    );
  }
}
