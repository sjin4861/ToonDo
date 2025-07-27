import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/onboarding/onboarding_screen.dart';
import 'package:presentation/views/auth/signup_step1.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupViewModel>(
      create: (_) {
        final viewModel = GetIt.instance<SignupViewModel>();
        // 화면 진입 시마다 상태 초기화
        viewModel.resetState();
        return viewModel;
      },
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isSignupComplete) {
            // Onboarding 페이지로 이동 (한 번만 실행되도록)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingScreen(),
                  ),
                );
              }
            });
          }
          Widget currentStepWidget;
          switch (viewModel.currentStep) {
            case 1:
              currentStepWidget = SignupStep1();
              break;
            default:
              currentStepWidget = SignupStep1(); // 기본값을 명확히 설정
          }
          return currentStepWidget;
        },
      ),
    );
  }
}