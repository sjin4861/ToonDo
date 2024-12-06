import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/user.dart';
import '../../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  String phoneNumber = '';
  String? phoneError;
  String password = '';
  String? passwordError;
  bool isSignupComplete = false;
  int? userId;
  int currentStep = 1; // currentStep 변수 추가

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }
  Future<void> validatePhoneNumber() async {
    AuthService authService = AuthService();
    try {
      if (phoneNumber.isEmpty || !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
        phoneError = '유효한 휴대폰 번호를 입력해주세요.';
      } else if (await authService.isPhoneNumberRegistered(phoneNumber)) {
        goToLogin(); // 로그인 화면으로 이동
      } else {
        phoneError = null;
        nextStep();
      }
    } catch (e) {
      phoneError = '전화번호 확인 중 오류가 발생했습니다.';
    }
    notifyListeners();
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