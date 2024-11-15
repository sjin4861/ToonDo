class Validators {
  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return '휴대폰 번호를 입력해주세요.';
    }
    if (!RegExp(r'^01[0-9]{8,9}$').hasMatch(value)) {
      return '유효한 휴대폰 번호를 입력해주세요.';
    }
    return null;
  }

  // 비밀번호 검증 (로그인용)
  static String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    return null;
  }

  // 비밀번호 검증 (회원가입용)
  static String? validatePassword(String value) {
    if (value.length < 8 || value.length > 20) {
      return '비밀번호는 8자 이상 20자 이하여야 합니다.';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@#$%^&+=!]*$').hasMatch(value)) {
      return '비밀번호에 영문과 숫자를 모두 포함해주세요.';
    }
    return null;
  }

  // 닉네임 검증
  static String? validateUsername(String value) {
    if (value.isEmpty) {
      return '닉네임을 입력해주세요.';
    }
    if (value.length > 6) {
      return '닉네임은 6자 이내여야 합니다.';
    }
    if (!RegExp(r'^[가-힣a-zA-Z0-9 ]+$').hasMatch(value)) {
      return '닉네임은 영문, 숫자, 한글만 가능합니다.';
    }
    return null;
  }
}