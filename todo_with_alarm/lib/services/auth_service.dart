

import 'package:todo_with_alarm/models/user.dart';

class AuthService {
  // 임시로 사용자 데이터를 저장하는 리스트
  final List<User> _users = [];

  // 싱글톤 패턴 적용 (필요 시)
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // 휴대폰 번호로 사용자 찾기
  User? findUserByPhoneNumber(String phoneNumber) {
    try {
      return _users.firstWhere(
        (user) => user.phoneNumber == phoneNumber,
      );
    } catch (e) {
      return null;
    }
  }

  // 사용자 등록
  void registerUser(User user) {
    _users.add(user);
  }

  // 사용자 로그인
  bool login(String phoneNumber, String password) {
    final user = findUserByPhoneNumber(phoneNumber);
    if (user != null && user.password == password) {
      return true;
    }
    return false;
  }
}