import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  // 기존 컨트롤러들
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController; // 추가된 컨트롤러

  String? passwordError;
  String? loginError;
  bool isPasswordVisible = false;

  LoginViewModel({String? phoneNumber})
      : phoneNumberController = TextEditingController(text: phoneNumber ?? ''),
        passwordController = TextEditingController(); // 초기화

  // 편의를 위해 getter 추가 (입력한 번호)
  String get phoneNumber => phoneNumberController.text;

  // 로그인 시에는 passwordController.text 사용
  Future<bool> login() async {
    bool isValid = validateInput();
    if (!isValid) return false;

    try {
      AuthService authService = AuthService();
      await authService.login(phoneNumber, passwordController.text);
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