import 'package:domain/usecases/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:presentation/views/auth/signup/steps/signup_step1.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => SignupViewModel(
            registerUserUseCase: GetIt.instance<RegisterUseCase>(),
            checkLoginIdExistsUseCase:
                GetIt.instance<CheckLoginIdExistsUseCase>(),
            loginUseCase: GetIt.instance<LoginUseCase>(),
          ),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isSignupComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
              );
            });
          }

          switch (viewModel.currentStep) {
            case 1:
              return const SignupStep1();
            default:
              return const SignupStep1();
          }
        },
      ),
    );
  }
}
