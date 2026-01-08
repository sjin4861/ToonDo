import 'package:flutter/material.dart';
import 'package:presentation/views/auth/login/login_body.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final String? passedLoginId =
        ModalRoute.of(context)?.settings.arguments as String?;
    // LoginViewModel이 singleton이라 이전 입력값이 남을 수 있어, 화면 진입 시 1회 초기화한다.
    final viewModel = GetIt.instance<LoginViewModel>();
    viewModel.reset(presetLoginId: passedLoginId);
  }

  @override
  Widget build(BuildContext context) {
    final String? passedLoginId =
        ModalRoute.of(context)?.settings.arguments as String?;

    return ChangeNotifierProvider<LoginViewModel>.value(
      value: GetIt.instance<LoginViewModel>(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return BaseScaffold(
            title: '로그인',
            body: LoginBody(passedLoginId: passedLoginId),
            bottomWidget: SafeArea(
              minimum: EdgeInsets.all(AppSpacing.a24),
              child: DoubleActionButtons(
                backText: '뒤로',
                nextText: '다음으로',
                onBack: () => Navigator.pop(context),
                onNext: () async {
                  final success = await viewModel.login();
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
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
