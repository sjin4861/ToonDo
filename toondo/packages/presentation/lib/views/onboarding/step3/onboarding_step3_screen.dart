import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:presentation/views/onboarding/onboarding_background.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:presentation/views/onboarding/step4/onboarding_step4_screen.dart';
import 'package:provider/provider.dart';

class OnboardingStep3Screen extends StatelessWidget {
  const OnboardingStep3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.step == 4) {
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingStep4Screen()),
          );
        });
      }
      if (viewModel.step == 2) {
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
          );
        });
      }
    });

    return Scaffold(
      appBar: AppNavBar(
        title: '시작하기',
        onBack: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const OnboardingBackground(step: 3),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    "당신의 이름도 저에게 알려 주실래요?",
                    style: AppTypography.h2Bold.copyWith(
                      color: AppColors.green500,
                    ),
                  ),
                  SizedBox(height: AppSpacing.v8),
                  Text(
                    "툰두에서 사용하고 싶은 닉네임을 적어주세요",
                    style: AppTypography.caption1Regular.copyWith(
                      color: AppColors.status100_75,
                    ),
                  ),
                  SizedBox(height: AppSpacing.v56),
                  AppInputField(
                    label: '닉네임',
                    controller: viewModel.nicknameController,
                    hintText: '8자 이내의 닉네임을 입력해주세요',
                    errorText: viewModel.nicknameError,
                    onChanged: viewModel.setNickname,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: DoubleActionButtons(
                      backText: '뒤로',
                      nextText: '다음으로',
                      onBack: () {
                        viewModel.step = 2;
                      },
                      onNext: () {
                        viewModel.validateNickname(
                          onSuccess: () {
                            viewModel.step = 4;
                          },
                          onError: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
