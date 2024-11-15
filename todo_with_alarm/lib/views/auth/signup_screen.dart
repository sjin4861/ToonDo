import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/viewmodels/auth/signup_viewmodel.dart';
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
            case -1:
              // 로그인 화면으로 이동
              // return LoginScreen();
              currentStepWidget = Container(); // 임시로 빈 컨테이너
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