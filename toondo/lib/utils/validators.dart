import '../constants/auth_constraints.dart';

class Validators {
  // 로그인 아이디 검증
  static String? validateLoginId(String value) {
    if (value.isEmpty) {
      return AuthConstraints.loginIdEmptyError;
    }
    if (value.length < AuthConstraints.loginIdMinLength || 
        value.length > AuthConstraints.loginIdMaxLength) {
      return AuthConstraints.loginIdLengthError;
    }
    if (!RegExp(AuthConstraints.loginIdPattern).hasMatch(value)) {
      return AuthConstraints.loginIdFormatError;
    }
    return null;
  }

  // 비밀번호 검증 (로그인용)
  static String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return AuthConstraints.passwordEmptyError;
    }
    return null;
  }

  // 비밀번호 검증 (회원가입용)
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return AuthConstraints.passwordEmptyError;
    }
    if (value.length < AuthConstraints.passwordMinLength || 
        value.length > AuthConstraints.passwordMaxLength) {
      return AuthConstraints.passwordLengthError;
    }
    if (!RegExp(AuthConstraints.passwordPattern).hasMatch(value)) {
      return AuthConstraints.passwordFormatError;
    }
    return null;
  }

  // 닉네임 검증
  static String? validateNickname(String value) {
    if (value.isEmpty) {
      return AuthConstraints.nicknameEmptyError;
    }
    if (value.length > AuthConstraints.nicknameMaxLength) {
      return AuthConstraints.nicknameLengthError;
    }
    if (!RegExp(AuthConstraints.nicknamePattern).hasMatch(value)) {
      return AuthConstraints.nicknameFormatError;
    }
    return null;
  }
}