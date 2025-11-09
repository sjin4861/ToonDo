import 'package:domain/usecases/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:presentation/views/auth/signup/steps/signup_step1.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:presentation/views/auth/login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SignupViewModel(
          registerUserUseCase: GetIt.instance<RegisterUseCase>(),
          checkLoginIdExistsUseCase: GetIt.instance<CheckLoginIdExistsUseCase>(),
          loginUseCase: GetIt.instance<LoginUseCase>(),
        );
        // 중복 아이디 즉시 로그인 화면 이동 콜백 등록
        // 실제 Navigator 호출은 아래 Consumer 빌드 시점에 안전하게 주입
        return vm;
      },
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, _) {
          // 콜백을 여기서 실제 Navigator 호출로 연결 (create 시 context 부재 문제 해결)
          viewModel.setNavigateToLogin(() {
            if (!context.mounted) return;
            // 빌드 중 네비게이션 호출 이슈 방지
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                  settings: RouteSettings(arguments: viewModel.loginId),
                ),
              );
            });
          });

          if (viewModel.isSignupComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
              );
            });
          }

          switch (viewModel.currentStep) {
            case SignupStep.loginId:
              return const SignupStep1();
            default:
              return const SignupStep1();
          }
        },
      ),
    );
  }
}
