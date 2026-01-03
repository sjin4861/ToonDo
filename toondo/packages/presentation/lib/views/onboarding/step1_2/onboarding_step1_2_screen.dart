import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/views/onboarding/onboarding_background.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_body.dart';
import 'package:presentation/views/onboarding/step3/onboarding_step3_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';

class OnboardingStep1To2Screen extends StatelessWidget {
  OnboardingStep1To2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => GetIt.I<OnboardingViewModel>()..startAutoProgress(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.step == 3) {
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => OnboardingStep3Screen()),
              );
            });
          }

          return Scaffold(
            backgroundColor: AppColors.backgroundNormal,
            body: SafeArea(
              child: Stack(
                children: [
                  OnboardingBackground(step: viewModel.step),
                  const OnboardingStep1To2Body(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
