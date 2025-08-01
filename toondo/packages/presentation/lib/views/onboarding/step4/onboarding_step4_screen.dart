import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/views/onboarding/onboarding_background.dart';
import 'package:presentation/views/onboarding/step3/onboarding_step3_screen.dart';
import 'package:presentation/views/onboarding/step4/onboarding_step4_body.dart';
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
            child: Column(
              children: [
                const OnboardingStep4Body(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacing24),
                  child: DoubleActionButtons(
                        backText: '괜찮아',
                        nextText: '좋아!',
                        onBack: () {
                          viewModel.nickname = '';
                          viewModel.step = 3;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => OnboardingStep3Screen()),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
