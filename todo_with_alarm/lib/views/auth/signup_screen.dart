import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/viewmodels/auth/signup_viewmodel.dart';
import 'package:todo_with_alarm/views/onboarding/onboarding_screen.dart';
import 'signup_step1.dart';
import 'signup_step2.dart';
import 'signup_step3.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isSignupComplete) {
            // Onboarding 페이지로 이동
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
              );
            });
          }
          Widget currentStepWidget;
          switch (viewModel.currentStep) {
            case 1:
              currentStepWidget = SignupStep1();
              break;
            case 2:
              currentStepWidget = SignupStep2();
              break;
            case 3:
              currentStepWidget = SignupStep3();
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