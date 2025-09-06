import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/auth/signup/steps/signup_step2_body.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';

class SignupStep2 extends StatelessWidget {
  final String loginId;

  SignupStep2({super.key, required this.loginId});

  @override
  Widget build(BuildContext context) {
    final signupViewModel = GetIt.instance<SignupViewModel>();

    if (signupViewModel.loginId.isEmpty) {
      signupViewModel.setLoginId(loginId);
    }

    return Consumer<SignupViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.onNavigateToOnboarding == null) {
          viewModel.setNavigateToOnboarding(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OnboardingStep1To2Screen()),
            );
          });
        }

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
