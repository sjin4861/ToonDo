import 'package:flutter/material.dart';
import 'package:todo_with_alarm/views/auth/signup_screen.dart';
import 'package:todo_with_alarm/views/home/home_screen.dart';

class WelcomeViewModel extends ChangeNotifier {
  // 소셜 로그인 처리 등을 위해 필요한 로직을 여기에 추가할 수 있습니다.

  void continueWithGoogle() {
    // Google 로그인 로직 구현
  }

  void continueWithKakao() {
    // Kakao 로그인 로직 구현
  }

  void continueWithPhoneNumber(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  // "로그인 없이 이용하기" 메서드 추가
  void continueWithoutLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}