import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../utils/validators.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // 회원가입 단계 관리
  int currentStep = 1;

  // 입력된 데이터 저장
  String phoneNumber = '';
  String password = '';

  // 에러 메시지 관리
  String? phoneError;
  String? passwordError;
  bool isSignupComplete = false; // 회원가입 완료 상태

  // 로그인 페이지로 이동하는 콜백 함수
  VoidCallback? navigateToLogin;

  // 로그인 페이지로 이동 설정
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }

  // 휴대폰 번호 검증 및 다음 단계로 이동 또는 로그인 페이지로 이동
  void validatePhoneNumber() {
    phoneError = Validators.validatePhoneNumber(phoneNumber);
    if (phoneError == null) {
      // 휴대폰 번호 존재 여부 확인
      final existingUser = _authService.findUserByPhoneNumber(phoneNumber);
      if (existingUser != null) {
        // 로그인 페이지로 이동
        if (navigateToLogin != null) {
          navigateToLogin!();
        }
      } else {
        // 다음 단계로 이동
        currentStep = 2;
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  // 비밀번호 검증 및 회원가입 완료 상태 업데이트
  void validatePassword() {
    passwordError = Validators.validatePassword(password);
    if (passwordError == null) {
      // 회원가입 로직 수행 (예: 서버에 사용자 정보 저장)
      // ...

      // 회원가입 완료 상태 업데이트
      isSignupComplete = true;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  // 이전 단계로 이동
  void goBack() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }
}