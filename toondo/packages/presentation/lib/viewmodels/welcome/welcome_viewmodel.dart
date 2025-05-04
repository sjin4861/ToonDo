import 'package:flutter/material.dart';
import 'package:domain/usecases/auth/get_token.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/views/auth/signup_screen.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/onboarding/onboarding_screen.dart';
import 'dart:convert';
import 'package:domain/usecases/auth/logout.dart';
import 'package:presentation/navigation/route_paths.dart';

@LazySingleton()
class WelcomeViewModel extends ChangeNotifier {
  final GetTokenUseCase getTokenUseCase;
  final LogoutUseCase logoutUseCase;

  WelcomeViewModel({required this.getTokenUseCase, required this.logoutUseCase});

  void continueWithGoogle() {
    // Google login logic implementation.
  }

  void continueWithKakao() {
    // Kakao login logic implementation.
  }

  void continueWithPhoneNumber(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  void continueWithoutLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  Future<void> checkIfLoggedIn(BuildContext context) async {
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
