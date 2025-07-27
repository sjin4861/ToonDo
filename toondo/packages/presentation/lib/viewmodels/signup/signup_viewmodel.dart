import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SignupViewModel extends ChangeNotifier {
  String loginId = '';
  String? loginIdError;
  String password = '';
  String? passwordError;
  String confirmPassword = '';
  String? confirmPasswordError;
  bool isSignupComplete = false;
  int? userId;
  int currentStep = 1;
  bool isLoading = false;

  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RegisterUseCase registerUserUseCase;
  final CheckLoginIdExistsUseCase checkLoginIdExistsUseCase;

  SignupViewModel({
    required this.registerUserUseCase,
    required this.checkLoginIdExistsUseCase,
  });

  VoidCallback? navigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    navigateToLogin = callback;
  }

  Future<bool> checkIfRegistered() async {
    return await checkLoginIdExistsUseCase(loginId);
  }

  Future<bool> validateLoginId() async {
    try {
      // 기본 검증
      if (loginId.isEmpty) {
        loginIdError = '아이디를 입력해주세요.';
        notifyListeners();
        return false;
      }
      if (loginId.length < 4 || loginId.length > 20) {
        loginIdError = '아이디는 4자 이상 20자 이하여야 합니다.';
        notifyListeners();
        return false;
      }
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(loginId)) {
        loginIdError = '아이디는 영문, 숫자, 언더바(_)만 사용 가능합니다.';
        notifyListeners();
        return false;
      }

      bool exists = await checkIfRegistered();
      if (exists) {
        // 아이디가 이미 존재하면 로그인 화면으로 이동
        if (navigateToLogin != null) {
          navigateToLogin!();
        }
        return false;
      } else {
        loginIdError = null;
        nextStep();
        notifyListeners();
        return true;
      }
    } catch (e) {
      loginIdError = '아이디 확인 중 오류가 발생했습니다.';
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp() async {
    try {
      User newUser = await registerUserUseCase.call(loginId, password);
      userId = newUser.id;
      isSignupComplete = true;
      notifyListeners();
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }

  void setLoginId(String id) {
    loginId = id;
    loginIdController.text = id;
    notifyListeners();
  }

  void setPassword(String pwd) {
    password = pwd;
    passwordController.text = pwd;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    confirmPasswordController.text = value;
    notifyListeners();
  }

  Future<void> validatePassword() async {
    if (password.isEmpty) {
      passwordError = '비밀번호를 입력해주세요.';
      notifyListeners();
      return;
    }
    if (password.length < 8 || password.length > 20) {
      passwordError = '비밀번호는 8자 이상 20자 이하여야 합니다.';
      notifyListeners();
      return;
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@#$%^&+=!]*$').hasMatch(password)) {
      passwordError = '비밀번호에 영문과 숫자를 모두 포함해주세요.';
      notifyListeners();
      return;
    }
    
    // 비밀번호 확인 검증
    if (confirmPassword.isEmpty) {
      confirmPasswordError = '비밀번호 확인을 입력해주세요.';
      notifyListeners();
      return;
    }
    if (password != confirmPassword) {
      confirmPasswordError = '비밀번호가 일치하지 않습니다.';
      notifyListeners();
      return;
    }
    
    passwordError = null;
    confirmPasswordError = null;
    notifyListeners();
    await signUp();
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
    loginIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}