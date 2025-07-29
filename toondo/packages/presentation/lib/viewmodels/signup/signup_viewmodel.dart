import 'package:domain/usecases/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:injectable/injectable.dart';
import 'package:common/constants/auth_constraints.dart';

enum SignupStep { loginId, password, done }

@injectable
class SignupViewModel extends ChangeNotifier {
  String loginId = '';
  String? loginIdError;
  String password = '';
  String? passwordError;
  String confirmPassword = '';
  String? confirmPasswordError;
  bool isSignupComplete = false;
  int? userId;
  SignupStep currentStep = SignupStep.loginId;
  bool isLoading = false;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  final TextEditingController loginIdTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController = TextEditingController();

  final RegisterUseCase registerUserUseCase;
  final CheckLoginIdExistsUseCase checkLoginIdExistsUseCase;
  final LoginUseCase loginUseCase;

  SignupViewModel({
    required this.registerUserUseCase,
    required this.checkLoginIdExistsUseCase,
    required this.loginUseCase,
  });

  /// 뷰모델 상태를 초기화 (화면 재진입 시 사용)
  void resetState() {
    loginId = '';
    loginIdError = null;
    password = '';
    passwordError = null;
    confirmPassword = '';
    confirmPasswordError = null;
    isSignupComplete = false;
    userId = null;
    currentStep = SignupStep.loginId;
    isLoading = false;

    loginIdTextController.clear();
    passwordTextController.clear();
    confirmPasswordTextController.clear();

    onNavigateToLogin = null;
    
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured = !isConfirmPasswordObscured;
    notifyListeners();
  }

  VoidCallback? onNavigateToLogin;
  void setNavigateToLogin(VoidCallback callback) {
    onNavigateToLogin = callback;
  }

  VoidCallback? onNavigateToOnboarding;
  void setNavigateToOnboarding(VoidCallback callback) {
    onNavigateToOnboarding = callback;
  }

  Future<bool> checkLoginIdExists() async {
    return await checkLoginIdExistsUseCase(loginId);
  }

  Future<bool> validateLoginId() async {
    try {
      // 기본 검증
      if (loginId.isEmpty) {
        loginIdError = AuthConstraints.loginIdEmptyError;
        notifyListeners();
        return false;
      }
      if (loginId.length < AuthConstraints.loginIdMinLength || loginId.length > AuthConstraints.loginIdMaxLength) {
        loginIdError = AuthConstraints.loginIdLengthError;
        notifyListeners();
        return false;
      }
      if (!RegExp(AuthConstraints.loginIdPattern).hasMatch(loginId)) {
        loginIdError = AuthConstraints.loginIdFormatError;
        notifyListeners();
        return false;
      }

      bool exists = await checkLoginIdExists();
      if (exists) {
        loginIdError = '이미 가입된 아이디입니다. 로그인을 시도해보세요.';
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          onNavigateToLogin?.call();
        });
        return false;
      } else {
        loginIdError = null;
        goToNextStep();
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
      await loginUseCase.call(loginId, password);
      isSignupComplete = true;
      currentStep = SignupStep.done;
      notifyListeners();
      onNavigateToOnboarding?.call();
    } catch (e) {
      print("회원가입 오류: $e");
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }

  void setLoginId(String id) {
    loginId = id;
    loginIdTextController.text = id;
    notifyListeners();
  }

  void setPassword(String pwd) {
    password = pwd;
    passwordTextController.text = pwd;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    confirmPasswordTextController.text = value;
    notifyListeners();
  }

  Future<void> validatePassword() async {
    if (password.isEmpty) {
      passwordError = AuthConstraints.passwordEmptyError;
      notifyListeners();
      return;
    }
    if (password.length < AuthConstraints.passwordMinLength || password.length > AuthConstraints.passwordMaxLength) {
      passwordError = AuthConstraints.passwordLengthError;
      notifyListeners();
      return;
    }
    if (!RegExp(AuthConstraints.passwordPattern).hasMatch(password)) {
      passwordError = AuthConstraints.passwordFormatError;
      notifyListeners();
      return;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = AuthConstraints.confirmPasswordEmptyError;
      notifyListeners();
      return;
    }
    if (password != confirmPassword) {
      confirmPasswordError = AuthConstraints.confirmPasswordMismatchError;
      notifyListeners();
      return;
    }
    
    passwordError = null;
    confirmPasswordError = null;
    notifyListeners();
    await signUp();
  }

  void goToPreviousStep() {
    if (currentStep == SignupStep.password) {
      currentStep = SignupStep.loginId;
      notifyListeners();
    }
  }

  void goToNextStep() {
    if (currentStep == SignupStep.loginId) {
      currentStep = SignupStep.password;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    loginIdTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
}