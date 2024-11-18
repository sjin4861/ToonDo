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
      AuthService authService = AuthService();
      await authService.login(phoneNumber!, password);
      // 로그인 성공 후 추가 작업 (예: 사용자 정보 로드)
      return true;
    } catch (e) {
      loginError = e.toString();
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