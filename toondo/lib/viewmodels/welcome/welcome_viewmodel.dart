import 'package:flutter/material.dart';
import 'package:toondo/services/auth_service.dart';
import 'package:toondo/views/auth/signup_screen.dart';
import 'package:toondo/views/home/home_screen.dart';
import 'package:toondo/views/onboarding/onboarding_screen.dart';

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

  // (테스트용) 온보딩 페이지로 이동하기 로직 추가
  void navigateToOnboarding(BuildContext context) {
    // 온보딩 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen(userId: 0)),
    );
  }

  Future<void> checkIfLoggedIn(BuildContext context) async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null || token.isEmpty) {
      // 토큰이 없으면 로그인 안 된 상태 -> 그냥 WelcomeScreen 계속 보여줌
      return;
    }

    final currentUser = authService.userBox.get('currentUser');
    if (currentUser == null) {
      // 토큰은 있는데 currentUser가 없으면? 
      // 보통은 서버로부터 user 정보 다시 불러오거나, 로그인 흐름 유도
      return;
    }

    // 여기까지 왔으면 완전히 로그인된 상태
    Navigator.pushReplacementNamed(context, '/home');
  }
}