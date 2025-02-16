import 'package:flutter/material.dart';
import '../../../packages/data/lib/models/user.dart';
import '../../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  String phoneNumber = '';
  String? phoneError;
  String password = '';
  String? passwordError;
  bool isSignupComplete = false;
  int? userId;
  int currentStep = 1; // currentStep 변수 추가

  // 신규: phoneNumberController 추가
  final TextEditingController phoneNumberController = TextEditingController();

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }

  // 추가: 등록된 유저인지 점검하는 메서드
  Future<bool> checkIfRegistered() async {
    AuthService authService = AuthService();
    return await authService.isPhoneNumberRegistered(phoneNumber);
  }

  /// 전화번호 유효성 검사 후, 이미 등록된 번호면 true를 반환, 신규면 false를 반환.
  Future<bool> validatePhoneNumber() async {
    try {
      if (phoneNumber.isEmpty || !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
        phoneError = '유효한 휴대폰 번호를 입력해주세요.';
        notifyListeners();
        return false;
      } 
      bool exists = await checkIfRegistered();
      if (exists) {
        // 이미 등록된 번호인 경우 (로그인 화면으로 진행)
        phoneError = null;
        notifyListeners();
        return true;
      } else {
        phoneError = null;
        nextStep();
        notifyListeners();
        return false;
      }
    } catch (e) {
      phoneError = '전화번호 확인 중 오류가 발생했습니다.';
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp() async {
    try {
      AuthService authService = AuthService();
      print('회원가입 시도: $phoneNumber, $password');
      User newUser = await authService.registerUser(phoneNumber, password);
      userId = newUser.id; // userId 저장
      isSignupComplete = true;
      notifyListeners();
    } catch (e) {
      // 에러 처리
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }
  
  // 수정: phoneNumberController의 text와 phoneNumber를 동시에 업데이트
  void setPhoneNumber(String number) {
    phoneNumber = number;
    phoneNumberController.text = number;
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
  
  // 기존 goToLogin 메서드는 더 이상 사용하지 않습니다.
  
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}