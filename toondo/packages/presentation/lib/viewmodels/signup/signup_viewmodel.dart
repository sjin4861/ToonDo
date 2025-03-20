import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/sms/send_sms_code.dart';
import 'package:domain/usecases/sms/verify_sms_code.dart';
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
  // 추가: passwordController 필드 추가
  final TextEditingController passwordController = TextEditingController();

  // 추가: SMS 인증 관련 필드
  final TextEditingController smsCodeController = TextEditingController();
  String smsMessage = "";
  bool isSmsLoading = false;

  final RegisterUseCase registerUserUseCase;
  final SendSmsCode sendSmsCodeUseCase;
  final VerifySmsCode verifySmsCodeUseCase;

  SignupViewModel({
    required this.registerUserUseCase,
    required this.sendSmsCodeUseCase,
    required this.verifySmsCodeUseCase,
  });

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }

  Future<String> sendSmsCode() async {
    try {
      return await sendSmsCodeUseCase.call(phoneNumber);
    } catch (e) {
      throw Exception('인증번호 전송에 실패했습니다: ${e.toString()}');
    }
  }

  Future<void> verifySmsCode(String code) async {
    try {
      await verifySmsCodeUseCase.call(phoneNumber, code);
    } catch (e) {
      throw Exception('인증번호 확인에 실패했습니다: ${e.toString()}');
    }
  }

  Future<void> sendSmsCodeAndSetState() async {
    isSmsLoading = true;
    smsMessage = "인증번호 전송 중...";
    notifyListeners();
    try {
      String result = await sendSmsCode();
      smsMessage = result;
    } catch (e) {
      smsMessage = e.toString();
    }
    isSmsLoading = false;
    notifyListeners();
  }

  Future<void> verifySmsCodeAndSetState() async {
    isSmsLoading = true;
    smsMessage = "";
    notifyListeners();
    if (smsCodeController.text == "0000") {
      // 인증번호가 0000이면 바로 통과
      isSmsLoading = false;
      smsMessage = "인증 성공!";
      notifyListeners();
      return;
    }
    try {
      await verifySmsCode(smsCodeController.text);
      smsMessage = "인증 성공!";
    } catch (e) {
      smsMessage = e.toString();
      rethrow;
    }
    isSmsLoading = false;
    notifyListeners();
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
    passwordController.dispose();
    // 추가: smsCodeController dispose
    smsCodeController.dispose();
    super.dispose();
  }
}