// services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/user.dart';
import 'package:toondo/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  static const String baseUrl = Constants.baseUrl;
  final http.Client httpClient = http.Client();
  final secureStorage = FlutterSecureStorage();

  // main.dart에서 'user' 박스를 열어두었으므로, 여기서 Hive.box<User>('user') 사용
  final Box<User> userBox = Hive.box<User>('user');

  /// JWT 토큰 저장
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  /// JWT 토큰 불러오기
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  /// 로그아웃 메서드
  Future<void> logout() async {
    // 토큰 삭제
    await secureStorage.delete(key: 'jwt_token');
    // 현재 사용자 정보 삭제
    await userBox.delete('currentUser');
    // 필요하다면 추가 정리 작업 수행
  }

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
      // print(responseData);
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
      await userBox.put('currentUser', newUser);
      return newUser;
    } else {
      // 에러 처리
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? '회원가입 실패');
    }
  }

  // 로그인
  Future<User> login(String phoneNumber, String password) async {
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

      // 서버 응답에서 닉네임이 null이거나 제공되지 않을 수 있으므로,
      // User 객체를 생성할 때 이를 고려합니다.
      User loggedInUser = User(
        id: responseData['userId'],
        phoneNumber: phoneNumber,
        username: responseData['nickname'],
      );
      // Hive에 캐싱
      await userBox.put('currentUser', loggedInUser);
      print('로그인 성공, currentUser 캐싱 완료');
      return loggedInUser;
    } else {
      // 에러 처리
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? '로그인 실패');
    }
  }

  /// 닉네임 업데이트
  Future<void> updateUsername(String nickname) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('토큰이 없습니다. 다시 로그인해주세요.');
    }

    final url = Uri.parse('$baseUrl/users/save-nickname');
    final response = await httpClient.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // 응답에 새로운 토큰이 제공되면 저장 (예: 동기화용)
      if (responseData['token'] != null) {
        await saveToken(responseData['token']);
      }
      // 로컬 Hive에 저장된 User 정보 업데이트
      User? currentUser = userBox.get('currentUser');
      if (currentUser != null) {
        currentUser.updateUsername(nickname);
        await userBox.put('currentUser', currentUser);
      }
    } else if (response.statusCode == 401) {
      throw Exception('닉네임 업데이트 실패: 잘못된 인증 정보입니다.');
    } else {
      throw Exception('닉네임 업데이트 실패: ${response.body}');
    }
  }

  // 휴대폰 번호 중복 확인
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    if (phoneNumber == Constants.testPhoneNumber) {
      return false;
    }
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
