import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  // 초기화 시 외부에서 전달된 번호가 있더라도 TextEditingController 사용
  final TextEditingController phoneNumberController;
  String password = '';
  String? passwordError;
  String? loginError;
  bool isPasswordVisible = false;

  LoginViewModel({String? phoneNumber})
      : phoneNumberController = TextEditingController(text: phoneNumber ?? '');
  // 편의를 위해 getter를 추가 (사용자가 입력한 번호)
  String get phoneNumber => phoneNumberController.text;

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
      await authService.login(phoneNumber, password);
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
    // 번호가 비어있으면 에러 처리
    if (phoneNumber.trim().isEmpty) {
      loginError = '휴대폰 번호를 입력해주세요.';
      isValid = false;
    }
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