import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/auth/signup/steps/signup_step2_body.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';

class SignupStep2 extends StatelessWidget {
  final String loginId;

  SignupStep2({super.key, required this.loginId});

  @override
  Widget build(BuildContext context) {
    final signupViewModel = context.read<SignupViewModel>();
    
    // TODO: setState() during build 에러 수정 완료 - build 중 notifyListeners() 호출 문제 해결
    // TODO: 해결책: WidgetsBinding.instance.addPostFrameCallback() 사용하여 빌드 완료 후 호출
    // TODO: 이전 문제: build() 메서드에서 setLoginId() 직접 호출 → notifyListeners() 트리거 → 빌드 중 재빌드 요청
    // TODO: 현재 해결: 빌드 완료 후 상태 변경으로 무한 빌드 루프 방지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signupViewModel.loginId.isEmpty) {
        signupViewModel.setLoginId(loginId);
      }
    });

    return Consumer<SignupViewModel>(
      builder: (context, viewModel, _) {
        // onNavigateToOnboarding 설정도 동일하게 수정
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.onNavigateToOnboarding == null) {
            viewModel.setNavigateToOnboarding(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
              );
            });
          }
        });

        return BaseScaffold(
          title: '회원정보 확인',
          body: SignupStep2Body(),
          bottomWidget: SafeArea(
            minimum: EdgeInsets.all(AppSpacing.a24),
            child: DoubleActionButtons(
              backText: '뒤로',
              nextText: '다음으로',
              onBack: () => Navigator.pop(context),
              onNext: () => viewModel.validatePassword(),
            ),
          ),
        );
      },
    );
  }
}
