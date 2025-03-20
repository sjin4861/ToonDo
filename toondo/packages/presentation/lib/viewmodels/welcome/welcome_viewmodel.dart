import 'package:flutter/material.dart';
import 'package:domain/usecases/auth/get_token.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/views/auth/signup_screen.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/onboarding/onboarding_screen.dart';

@LazySingleton()
class WelcomeViewModel extends ChangeNotifier {
  final GetTokenUseCase getTokenUseCase;

  WelcomeViewModel({required this.getTokenUseCase});

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
    Navigator.pushReplacementNamed(context, '/home');
  }
}
