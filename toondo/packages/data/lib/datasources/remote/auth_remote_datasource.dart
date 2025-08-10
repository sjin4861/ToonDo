import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthRemoteDataSource{
  final http.Client httpClient;
  AuthRemoteDataSource(this.httpClient);

  static const String baseUrl = Constants.baseUrl;

  /// 사용자를 회원가입시키는 함수.
  ///
  /// 서버의 `/users/signup` 엔드포인트에 `POST` 요청을 보내어
  /// 새로운 사용자를 등록하고, 성공하면 `UserModel`을 반환합니다.
  ///
  /// [loginId] 사용자의 로그인 아이디
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
  ///   final user = await registerUser('user123', 'password123');
  ///   print('회원가입 성공: ${user.token}');
  /// } catch (e) {
  ///   print('회원가입 실패: $e');
  /// }
  /// ```
  Future<String> registerUser(
    String loginId,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/signup');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': loginId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['accessToken'];
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? '이미 존재하는 로그인 ID입니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류가 발생했습니다.');
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  Future<String> login(
    String loginId,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': loginId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['accessToken'];
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? '로그인 정보가 올바르지 않습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 내부 오류가 발생했습니다.');
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  Future<bool> isLoginIdRegistered(String loginId) async {
    final url = Uri.parse('$baseUrl/users/check-loginid?loginid=$loginId');
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true;
    }
    throw Exception('아이디 확인 실패: ${response.body}');
  }

  Future<void> deleteAccount() async {
    // TODO: 개발 중에는 목 응답 사용, 실제 서버 연결 시 아래 주석 해제
    // 임시로 성공 응답 시뮬레이션
    await Future.delayed(Duration(milliseconds: 1000)); // 네트워크 지연 시뮬레이션
    
    /* 실제 서버 연결 코드
    final url = Uri.parse('$baseUrl/users/delete-account');
    final response = await httpClient.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('계정 탈퇴 실패: ${response.body}');
    }
    */
  }
}
