import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/auth/signup/steps/signup_step1_body.dart';
import 'package:presentation/views/auth/signup/steps/signup_step2.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';

class SignupStep1 extends StatelessWidget {
  const SignupStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, child) {
        return BaseScaffold(
          title: '회원가입',
          body: SignupStep1Body(),
          bottomWidget: SafeArea(
            minimum: EdgeInsets.all(AppSpacing.spacing24),
            child: DoubleActionButtons(
              backText: '뒤로',
              nextText: '아이디 중복 확인하기',
              onBack: () {
                Navigator.pop(context);
              },
              onNext: () {
                viewModel.validateLoginId().then((isValid) {
                  if (isValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupStep2(loginId: viewModel.loginId),
                      ),
                    );
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }
}
