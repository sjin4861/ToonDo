import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/login.dart'; // new import
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoginViewModel extends ChangeNotifier {
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;

  final LoginUseCase loginUseCase; // New dependency

  String? passwordError;
  String? loginError;
  bool isPasswordVisible = false;

  LoginViewModel({
    String? phoneNumber,
    required this.loginUseCase, // Injected via DI
  }) : phoneNumberController = TextEditingController(text: phoneNumber ?? ''),
       passwordController = TextEditingController();

  String get phoneNumber => phoneNumberController.text;

  Future<bool> login() async {
    bool isValid = validateInput();
    if (!isValid) return false;
    try {
      User user = await loginUseCase.call(phoneNumber, passwordController.text);
      // Optionally store user info if needed.
      return true;
    } catch (e) {
      loginError = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool validateInput() {
    bool isValid = true;
    if (phoneNumber.trim().isEmpty) {
      loginError = '휴대폰 번호를 입력해주세요.';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = '비밀번호를 입력해주세요.';
      isValid = false;
    } else {
      passwordError = null;
    }
    notifyListeners();
    return isValid;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void setPassword(String password) {
    passwordController.text = password;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
