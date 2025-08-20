import 'package:flutter/material.dart';
import 'package:presentation/views/auth/login/login_body.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? passedLoginId = ModalRoute.of(context)?.settings.arguments as String?;

    return ChangeNotifierProvider<LoginViewModel>.value(
      value: GetIt.instance<LoginViewModel>(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          if (passedLoginId != null && viewModel.loginIdController.text.isEmpty) {
            viewModel.loginIdController.text = passedLoginId;
          }

          return BaseScaffold(
            title: '로그인',
            body: LoginBody(passedLoginId: passedLoginId),
            bottomWidget: SafeArea(
              minimum: EdgeInsets.all(AppSpacing.spacing24),
              child: DoubleActionButtons(
                backText: '뒤로',
                nextText: '다음으로',
                onBack: () => Navigator.pop(context),
                onNext: () async {
                  final success = await viewModel.login();
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.loginError ?? '로그인에 실패했습니다.'),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
