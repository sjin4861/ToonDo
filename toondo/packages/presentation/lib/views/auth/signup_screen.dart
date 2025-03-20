import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/onboarding/onboarding_screen.dart';
import 'package:presentation/views/auth/signup_step1.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupViewModel>.value(
      value: GetIt.instance<SignupViewModel>(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isSignupComplete) {
            // Onboarding 페이지로 이동
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OnboardingScreen(),
                ),
              );
            });
          }
          Widget currentStepWidget;
          switch (viewModel.currentStep) {
            case 1:
              currentStepWidget = SignupStep1();
              break;
            default:
              currentStepWidget = Container();
          }
          return currentStepWidget;
        },
      ),
    );
  }
}