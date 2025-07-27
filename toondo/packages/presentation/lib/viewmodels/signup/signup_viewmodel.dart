import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/auth/register.dart';
import 'package:domain/usecases/auth/check_login_id_exists.dart';
import 'package:injectable/injectable.dart';
import 'package:common/constants/auth_constraints.dart';

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
    currentStep = 1;
    isLoading = false;
    
    loginIdController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    
    navigateToLogin = null;
    
    notifyListeners();
  }

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

      bool exists = await checkIfRegistered();
      if (exists) {
        // 아이디가 이미 존재함을 사용자에게 명확히 알림
        loginIdError = '이미 가입된 아이디입니다. 로그인을 시도해보세요.';
        notifyListeners();
        
        // 잠시 후 로그인 화면으로 이동
        Future.delayed(Duration(seconds: 2), () {
          if (navigateToLogin != null) {
            navigateToLogin!();
          }
        });
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
    
    // 비밀번호 확인 검증
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
    confirmPasswordController.dispose();
    super.dispose();
  }
}