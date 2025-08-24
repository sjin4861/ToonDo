import 'package:flutter/material.dart';
import 'package:domain/usecases/auth/get_token.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/views/auth/signup/signup_screen.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/onboarding/step1_2/onboarding_step1_2_screen.dart';
import 'dart:convert';
import 'package:domain/usecases/auth/logout.dart';
import 'package:presentation/navigation/route_paths.dart';

@injectable
class WelcomeViewModel extends ChangeNotifier {
  final GetTokenUseCase getTokenUseCase;
  final LogoutUseCase logoutUseCase;

  WelcomeViewModel({required this.getTokenUseCase, required this.logoutUseCase});

  Future<void> init(BuildContext context) async {
    await _checkIfLoggedIn(context);
  }

  void continueWithGoogle(BuildContext context) {
    // Todo: 구글 로그인 구현
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
    );
  }

  void continueWithKakao(BuildContext context) {
    // Todo: 카카오 로그인 구현. 임시로 홈 화면으로 이동
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
    );
  }

  void continueWithPhoneNumber(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  void continueWithoutLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
    );
  }

  void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingStep1To2Screen()),
    );
  }

  Future<void> _checkIfLoggedIn(BuildContext context) async {
    final token = await getTokenUseCase();
    if (token == null || token.isEmpty) return;
    if (_isTokenExpired(token)) {
      await logoutUseCase();
      return;
    }
    Navigator.pushReplacementNamed(context, RoutePaths.home);
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final payloadMap = json.decode(utf8.decode(base64Url.decode(normalized)));
      if (payloadMap is! Map<String, dynamic> || !payloadMap.containsKey('exp')) return true;
      final exp = payloadMap['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp < now;
    } catch (_) {
      return true;
    }
  }
}
