import 'package:todo_with_alarm/models/user.dart';

class AuthService {
  // 임시로 사용자 데이터를 저장하는 리스트
  final List<User> _users = [];

  // 싱글톤 패턴 적용
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
  Future<void> registerUser(User user) async {
    // 이미 등록된 사용자 확인
    final existingUser = findUserByPhoneNumber(user.phoneNumber);
    if (existingUser == null) {
      _users.add(user);
    } else {
      throw Exception('이미 등록된 휴대폰 번호입니다.');
    }
  }

  // 사용자 로그인
  Future<bool> login(String phoneNumber, String password) async {
    final user = findUserByPhoneNumber(phoneNumber);
    if (user != null && user.password == password) {
      return true;
    }
    return false;
  }

  // 휴대폰 번호가 등록되었는지 확인
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final user = findUserByPhoneNumber(phoneNumber);
    return user != null;
  }
}