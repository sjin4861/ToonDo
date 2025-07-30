import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/auth/signup/steps/signup_step1.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:provider/provider.dart';

class SignupScaffold extends StatelessWidget {
  const SignupScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.isSignupComplete && Navigator.canPop(context)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
            );
          }
        });

        switch (viewModel.currentStep) {
          case 1:
            return const SignupStep1();
        // case 2:
        //   return SignupStep2();
          default:
            return const SignupStep1(); // fallback
        }
      },
    );
  }
}
