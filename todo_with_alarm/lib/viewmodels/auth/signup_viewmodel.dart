import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/user.dart';
import '../../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  String phoneNumber = '';
  String? phoneError;
  String password = '';
  String? passwordError;
  bool isSignupComplete = false;
  String? userId;
  int currentStep = 1; // currentStep 변수 추가

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }
  void validatePhoneNumber() {
    // 휴대폰 번호 유효성 검사 로직 추가
    if (phoneNumber.isEmpty || !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
      phoneError = '유효한 휴대폰 번호를 입력해주세요.';
      notifyListeners();
    } else {
      phoneError = null;
      notifyListeners();
      nextStep();
    }
  }

  Future<void> signUp() async {
    try {
      AuthService authService = AuthService();
      User newUser = await authService.registerUser(phoneNumber, password);
      userId = newUser.id; // userId 저장
      isSignupComplete = true;
      notifyListeners();
    } catch (e) {
      // 에러 처리
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }
  

  void setPhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }

  void setPassword(String pwd) {
    password = pwd;
    notifyListeners();
  }

  Future<void> validatePassword() async {
    if (password.length >= 8 && password.length <= 20) {
      passwordError = null;
      notifyListeners();
      await signUp();
    } else {
      passwordError = '비밀번호는 8자 이상 20자 이하여야 합니다.';
      notifyListeners();
    }
  }

  void goBack() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }

  void nextStep() {
    currentStep++;
    notifyListeners();
  }
  
  void goToLogin() {
    if (navigateToLogin != null) {
      navigateToLogin!();
    }
  }
}