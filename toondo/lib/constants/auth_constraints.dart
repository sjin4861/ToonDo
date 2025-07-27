/// 인증 관련 제약사항을 정의하는 상수 클래스
class AuthConstraints {
  // 로그인 아이디 제약사항
  static const int loginIdMinLength = 4;
  static const int loginIdMaxLength = 20;
  static const String loginIdPattern = r'^[a-zA-Z0-9_]+$';
  static const String loginIdDescription = '영문, 숫자, 언더바(_)만 사용 가능하며, 4-20자로 입력해주세요.';
  
  // 비밀번호 제약사항
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 20;
  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@#$%^&+=!]*$';
  static const String passwordDescription = '영문과 숫자를 조합한 8-20자로 입력해주세요.';
  
  // 닉네임 제약사항
  static const int nicknameMinLength = 1;
  static const int nicknameMaxLength = 6;
  static const String nicknamePattern = r'^[가-힣a-zA-Z0-9 ]+$';
  static const String nicknameDescription = '영문, 숫자, 한글만 사용 가능하며, 1-6자로 입력해주세요.';
  
  // 에러 메시지
  static const String loginIdEmptyError = '아이디를 입력해주세요.';
  static const String loginIdLengthError = '아이디는 4자 이상 20자 이하여야 합니다.';
  static const String loginIdFormatError = '아이디는 영문, 숫자, 언더바(_)만 사용 가능합니다.';
  
  static const String passwordEmptyError = '비밀번호를 입력해주세요.';
  static const String passwordLengthError = '비밀번호는 8자 이상 20자 이하여야 합니다.';
  static const String passwordFormatError = '비밀번호에 영문과 숫자를 모두 포함해주세요.';
  
  static const String nicknameEmptyError = '닉네임을 입력해주세요.';
  static const String nicknameLengthError = '닉네임은 6자 이내여야 합니다.';
  static const String nicknameFormatError = '닉네임은 영문, 숫자, 한글만 가능합니다.';
}
