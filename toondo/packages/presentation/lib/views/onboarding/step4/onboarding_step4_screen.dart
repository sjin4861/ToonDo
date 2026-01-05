import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/views/onboarding/onboarding_background.dart';
import 'package:presentation/views/onboarding/step4/onboarding_step4_body.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';

class OnboardingStep4Screen extends StatelessWidget {
  const OnboardingStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundNormal,
      body: Stack(
        children: [
          OnboardingBackground(step: viewModel.step),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.a24),
              child: Column(
                children: [
                  const OnboardingStep4Body(),
                  const Spacer(),
                  DoubleActionButtons(
                    backText: '괜찮아',
                    nextText: '좋아!',
                    onBack: () {
                      // 온보딩을 건너뛰고 메인 화면으로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false, // 모든 이전 라우트 제거
                      );
                    },
                    onNext: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalInputScreen(isFromOnboarding: true),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
