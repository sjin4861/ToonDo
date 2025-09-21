import 'package:domain/usecases/auth/login.dart';
import 'package:data/constants.dart'; // for test bypass constants
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
  // TODO(loading-state): 버튼 클릭 시 로딩 표시/중복 클릭 방지를 위해 isLoading 체크 & 설정 필요
  // if (isLoading) return false; // 중복 호출 방지 예시
  // isLoading = true; notifyListeners();
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

      // TODO(timeout): 네트워크 지연 무한 대기 방지를 위해 timeout 적용 고려
      // bool exists = await checkLoginIdExists().timeout(const Duration(seconds: 8));
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
    // finally {
    //   isLoading = false; notifyListeners();
    // }
  }

  Future<void> signUp() async {
    // Local test bypass: 완전 오프라인 처리 (원격 호출 X)
    // loginId가 비어있으면 TextController에서 복구 (UI에서 setLoginId 호출 누락 대비)
    if (loginId.isEmpty && loginIdTextController.text.isNotEmpty) {
      loginId = loginIdTextController.text.trim();
      print('SignupViewModel: recovered loginId from controller -> $loginId');
    }
    print('SignupViewModel: signUp called with loginId=$loginId');
    if (Constants.enableLocalTestBypass &&
        loginId == Constants.testLoginId &&
        password == Constants.testPassword) {
      print('🧪[TEST SIGNUP BYPASS] local completion for testuser');
      isSignupComplete = true;
      currentStep = SignupStep.done;
      notifyListeners();
      onNavigateToOnboarding?.call();
      return;
    }
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
    // print('SignupViewModel: setLoginId called with id=$id');
    
    // TODO: setState() during build 에러 해결 - notifyListeners() 호출 최적화
    // TODO: 문제: build() 메서드에서 이 메서드가 호출되어 notifyListeners()가 빌드 중 재빌드를 요청
    // TODO: 해결 방안 1: 값이 실제로 변경될 때만 notifyListeners() 호출
    // TODO: 해결 방안 2: _setLoginIdSilent() 같은 조용한 setter 메서드 제공
    // TODO: 해결 방안 3: didUpdateWidget이나 initState에서만 호출되도록 호출 지점 수정
    // TODO: 임시 해결: 값이 동일하면 notifyListeners() 생략
    if (loginId == id) return; // 동일한 값이면 업데이트 생략
    
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
    // 누락된 loginId 복구 시도
    print('SignupViewModel: validatePassword called with loginId=$loginId');
    print(loginIdTextController.text);
    if (loginId.isEmpty && loginIdTextController.text.isNotEmpty) {
      loginId = loginIdTextController.text.trim();
      print('SignupViewModel: recovered loginId in validatePassword -> $loginId');
    }
    // TEST ACCOUNT EXCEPTION (패턴/숫자 요구 무시, confirm 비어있으면 자동 채움)
    if (loginId == Constants.testLoginId && password == Constants.testPassword) {
      if (password.isEmpty) {
        passwordError = AuthConstraints.passwordEmptyError;
        notifyListeners();
        return;
      }
      if (confirmPassword.isEmpty) {
        // 사용자 편의: 자동 동일 값 세팅
        confirmPassword = password;
        confirmPasswordTextController.text = password;
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
      return;
    }

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