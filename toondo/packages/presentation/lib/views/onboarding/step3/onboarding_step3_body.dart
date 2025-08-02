import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';

class OnboardingStep3Body extends StatelessWidget {
  const OnboardingStep3Body({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.spacing64),
        _buildHeaderText(),
        const SizedBox(height: AppSpacing.spacing56),
        AppInputField(
          label: '닉네임',
          controller: viewModel.nicknameController,
          hintText: '사용할 닉네임을 입력해주세요!',
          errorText: viewModel.nicknameError,
          onChanged: (value) {
            if (viewModel.nicknameError != null) {
              viewModel.nicknameError = null;
              viewModel.notifyListeners();
            }
          },
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임을 설정해주세요',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        Text(
          '앱에서 사용할 닉네임을 입력해주세요.',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
      ],
    );
  }
}
