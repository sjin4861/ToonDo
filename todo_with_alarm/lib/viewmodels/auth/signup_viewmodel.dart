import 'package:flutter/material.dart';
import 'package:todo_with_alarm/services/auth_service.dart';
import 'package:todo_with_alarm/models/user.dart';
import 'package:todo_with_alarm/utils/validators.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // 회원가입 단계 관리
  int currentStep = 1;

  // 입력된 데이터 저장
  String phoneNumber = '';
  String password = '';
  String username = '';


  // 에러 메시지 관리
  String? phoneError;
  String? passwordError;
  String? usernameError;

  bool isSignupComplete = false;

  // 휴대폰 번호 검증 및 다음 단계로 이동
  void validatePhoneNumber() {
    phoneError = Validators.validatePhoneNumber(phoneNumber);
    if (phoneError == null) {
      // 휴대폰 번호 존재 여부 확인
      final existingUser = _authService.findUserByPhoneNumber(phoneNumber);
      if (existingUser != null) {
        // 로그인 페이지로 이동
        currentStep = -1; // 로그인 페이지를 -1로 가정
      } else {
        // 다음 단계로 이동
        currentStep = 2;
      }
    }
    notifyListeners();
  }

  // 비밀번호 검증 및 다음 단계로 이동
  void validatePassword() {
    passwordError = Validators.validatePassword(password);
    if (passwordError == null) {
      currentStep = 3;
    }
    notifyListeners();
  }

  void validateUsername() {
    usernameError = Validators.validateUsername(username);
    if (usernameError == null) {
      // 사용자 등록
      _authService.registerUser(User(
        phoneNumber: phoneNumber,
        password: password,
        username: username,
      ));
      // 회원가입 완료 상태 업데이트
      isSignupComplete = true;
      notifyListeners();
    }
  }

  // 뒤로가기
  void goBack() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }
}