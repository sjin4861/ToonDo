import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  String? phoneNumber;
  String password = '';
  String? passwordError;
  String? loginError;
  bool isPasswordVisible = false;

  LoginViewModel({this.phoneNumber});

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> login() async {
    bool isValid = validateInput();
    if (!isValid) {
      return false;
    }

    try {
      // AuthService를 사용하여 로그인 로직 수행
      AuthService authService = AuthService();
      bool success = await authService.login(phoneNumber!, password);
      if (success) {
        return true;
      } else {
        loginError = '비밀번호를 다시 확인해주세요.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      loginError = '로그인 중 오류가 발생했습니다.';
      notifyListeners();
      return false;
    }
  }

  bool validateInput() {
    bool isValid = true;

    if (password.isEmpty) {
      passwordError = '비밀번호를 입력해주세요.';
      isValid = false;
    } else {
      passwordError = null;
    }

    notifyListeners();
    return isValid;
  }
}