import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String phoneNumber = '';
  String password = '';

  String? phoneError;
  String? passwordError;
  String? loginError;

  // 로그인 처리
  void login() {
    // 입력값 검증
    phoneError = Validators.validatePhoneNumber(phoneNumber);
    passwordError = Validators.validateLoginPassword(password);

    if (phoneError == null && passwordError == null) {
      // 로그인 시도
      bool success = _authService.login(phoneNumber, password);
      if (success) {
        // 로그인 성공
        loginError = null;
        // 메인 화면으로 이동하는 로직을 View에서 처리하거나,
        // 상태 변수를 업데이트하여 Consumer에서 처리합니다.
        notifyListeners();
      } else {
        // 로그인 실패
        loginError = '휴대폰 번호 또는 비밀번호가 올바르지 않습니다.';
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }
}