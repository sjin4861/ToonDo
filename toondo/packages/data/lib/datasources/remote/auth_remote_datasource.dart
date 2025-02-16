import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data/models/user_model.dart';
import 'package:data/constants.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> registerUser(
    String phoneNumber,
    String password,
  );
  Future<Map<String, dynamic>> login(String phoneNumber, String password);
  Future<bool> isPhoneNumberRegistered(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client httpClient;
  AuthRemoteDataSourceImpl(this.httpClient);

  static const String baseUrl = Constants.baseUrl;

  /// 사용자를 회원가입시키는 함수.
  ///
  /// 서버의 `/users/signup` 엔드포인트에 `POST` 요청을 보내어
  /// 새로운 사용자를 등록하고, 성공하면 `UserModel`을 반환합니다.
  ///
  /// [phoneNumber] 사용자의 전화번호 (- 제외)
  /// [password] 사용자의 비밀번호
  ///
  /// 성공 시:
  /// - HTTP 상태 코드 200(OK) 또는 201(Created)
  /// - 응답 본문에 JWT 토큰과 사용자 정보 포함
  ///
  /// 실패 시:
  /// - 400 BAD REQUEST: 이미 존재하는 로그인 ID
  /// - 500 INTERNAL SERVER ERROR: 서버 오류 발생
  /// - 예외를 던져 호출한 곳에서 처리하도록 함
  ///
  /// 예제:
  /// ```dart
  /// try {
  ///   final user = await registerUser('01012345678', 'password123');
  ///   print('회원가입 성공: ${user.token}');
  /// } catch (e) {
  ///   print('회원가입 실패: $e');
  /// }
  /// ```
  @override
  Future<Map<String, dynamic>> registerUser(
    String phoneNumber,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData; // Return raw response data
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData;
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  @override
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/users/check-phone-number');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['exists'];
    } else {
      throw Exception('휴대폰 번호 확인 실패');
    }
  }
}
