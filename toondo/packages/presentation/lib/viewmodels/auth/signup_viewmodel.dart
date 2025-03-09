import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SignupViewModel extends ChangeNotifier {
  String phoneNumber = '';
  String? phoneError;
  String password = '';
  String? passwordError;
  bool isSignupComplete = false;
  int? userId;
  int currentStep = 1;

  final TextEditingController phoneNumberController = TextEditingController();

  final RegisterUseCase registerUserUseCase;

  SignupViewModel({required this.registerUserUseCase});

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }

  Future<bool> checkIfRegistered() async {
    return false;
  }

  Future<bool> validatePhoneNumber() async {
    try {
      if (phoneNumber.isEmpty ||
          !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
        phoneError = '유효한 휴대폰 번호를 입력해주세요.';
        notifyListeners();
        return false;
      }
      bool exists = await checkIfRegistered();
      if (exists) {
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
      User newUser = await registerUserUseCase.call(phoneNumber, password);
      userId = newUser.id;
      isSignupComplete = true;
      notifyListeners();
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }

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

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
