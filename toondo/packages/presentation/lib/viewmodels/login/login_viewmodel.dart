import 'package:flutter/material.dart';
import 'package:domain/usecases/auth/login.dart'; // new import
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoginViewModel extends ChangeNotifier {
  final TextEditingController loginIdController;
  final TextEditingController passwordController;

  final LoginUseCase loginUseCase; // New dependency

  String? loginIdError;
  String? passwordError;
  // 로그인 실패(서버/네트워크 등)와 같이 필드에 귀속되지 않는 에러
  String? loginError;
  bool isPasswordVisible = false;

  LoginViewModel({
    required this.loginUseCase, // Injected via DI
  }) : loginIdController = TextEditingController(),
       passwordController = TextEditingController();

  String get loginId => loginIdController.text;

  void reset({String? presetLoginId}) {
    loginIdController.text = presetLoginId ?? '';
    passwordController.clear();
    loginIdError = null;
    passwordError = null;
    loginError = null;
    isPasswordVisible = false;
    notifyListeners();
  }

  Future<bool> login() async {
    // 이전 에러 상태 초기화
    loginIdError = null;
    passwordError = null;
    loginError = null;

    bool isValid = validateInput();
    if (!isValid) return false;
    try {
      await loginUseCase.call(loginId, passwordController.text);
      // Optionally store user info if needed.
      return true;
    } catch (e) {
      _applyLoginFailureMessage(e);
      notifyListeners();
      return false;
    }
  }

  bool validateInput() {
    bool isValid = true;
    if (loginId.trim().isEmpty) {
      loginIdError = '아이디를 입력해주세요.';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = '비밀번호를 입력해주세요.';
      isValid = false;
    } else {
      passwordError = null;
    }
    notifyListeners();
    return isValid;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void onLoginIdChanged(String value) {
    if (loginIdError != null || loginError != null) {
      loginIdError = null;
      loginError = null;
      notifyListeners();
    }
  }

  void setPassword(String password) {
    passwordController.text = password;
    if (passwordError != null || loginError != null) {
      passwordError = null;
      loginError = null;
    }
    notifyListeners();
  }

  void _applyLoginFailureMessage(Object error) {
    final String raw = error.toString();

    // 백엔드/데이터레이어에서 내려오는 문자열: "Exception: 로그인 실패: {status: 401, errorCode: Unauthorized, message: Invalid password}"
    final lower = raw.toLowerCase();

    // 비밀번호 불일치
    if (lower.contains('invalid password') ||
        (lower.contains('401') &&
            (lower.contains('unauthorized') ||
                lower.contains('unauthorised')))) {
      passwordError = '비밀번호가 올바르지 않습니다.';
      return;
    }

    // 그 외에는 과도한 예외 문자열을 그대로 노출하지 않음
    loginError = '로그인에 실패했습니다. 다시 시도해주세요.';
  }

  @override
  void dispose() {
    loginIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
