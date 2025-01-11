// services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:todo_with_alarm/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String baseUrl = Constants.baseUrl;

  final _storage = FlutterSecureStorage();

  // 회원가입
  Future<User> registerUser(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 회원가입 성공
      final responseData = jsonDecode(response.body);
      // responseData값 실제 출력
      print(responseData);
      //responseData의 각 key에 맞게 User 객체 생성
      // 'Bearer ' 접두사를 제거하고 순수한 JWT 토큰 저장
      String tokenWithBearer = responseData['token'];
      String token = tokenWithBearer.startsWith('Bearer ')
          ? tokenWithBearer.substring(7)
          : tokenWithBearer;
      await saveToken(token);

      User newUser = User(
        id: responseData['userId'],
        phoneNumber: phoneNumber,
        username: responseData['nickname'],
      );
      return newUser;
    } else {
      // 에러 처리
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? '회원가입 실패');
    }
  }
  // 로그인
  Future<void> login(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      final responseData = jsonDecode(response.body);

      // 토큰 저장 (예: JWT 토큰)
      String tokenWithBearer = responseData['token'];
      String token = tokenWithBearer.startsWith('Bearer ')
          ? tokenWithBearer.substring(7)
          : tokenWithBearer;
      await saveToken(token);

      // 사용자 정보 저장 (필요한 경우)
      // User user = User.fromJson(responseData['user']);
      // await _storage.write(key: 'userId', value: user.id);

      print('로그인 성공');
    } else {
      // 에러 처리
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? '로그인 실패');
    }
  }
  // 닉네임 업데이트 메서드
  Future<User> updateUsername(int userId, String nickname) async {
    final url = Uri.parse('$baseUrl/users/update-my');
    final token = await getToken(); // 로그인 시 저장한 토큰을 가져옵니다.

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가
      },
      body: jsonEncode({
        'username': nickname,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // 닉네임 업데이트 성공
      print('닉네임 업데이트 성공');
      // 'Bearer ' 접두사를 제거하고 순수한 JWT 토큰 저장 (응답에 새로운 토큰이 포함될 경우)
      String tokenWithBearer = responseData['token'];
      String newToken = tokenWithBearer.startsWith('Bearer ')
          ? tokenWithBearer.substring(7)
          : tokenWithBearer;
      await saveToken(newToken);

      // 업데이트된 사용자 정보 반환
      User updatedUser = User(
        id: responseData['userId'],
        phoneNumber: responseData['loginId'],
        username: responseData['nickname'],
      );
      return updatedUser;
    } else {
      // 에러 처리
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? '닉네임 업데이트 실패');
    }
  }

  // 토큰 저장 메서드 (로그인 시 사용)
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // 토큰 가져오기 메서드
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
  // 휴대폰 번호 중복 확인
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/users/check-phone-number');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // 헤더 추가
      body: jsonEncode({'loginId': phoneNumber}), // JSON 인코딩
    );
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['exists'];
    } else {
      throw Exception('Failed to check phone number');
    }
  }
}
