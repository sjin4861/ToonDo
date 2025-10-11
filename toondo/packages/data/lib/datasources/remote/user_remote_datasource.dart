import 'dart:convert';
import 'package:data/models/user_model.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart'; // reuse if token retrieval similar

@LazySingleton()
class UserRemoteDatasource {
  http.Client client;
  final AuthRepository authRepository;

  UserRemoteDatasource(this.client, this.authRepository);


  Future<User> getUserMe() async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');
    
    final url = Uri.parse('${Constants.baseUrl}/users/me');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == '내 정보 조회 성공') {
        // API 응답에 createdAt이 포함되어 있다면 UserModel.fromJson에서 처리됩니다.
        return UserModel.fromJson(data).toEntity();
      }
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 오류가 발생했습니다.');
    }
    
    throw Exception('내 정보 조회 실패: ${response.body}');
  }

  /// 사용자의 비밀번호를 수정하는 메서드
  /// 
  /// URL 옵션들:
  /// - 현재 구현: `/users/me/password` (PATCH)
  /// - API 문서: `/users/update-password` (PUT)
  /// 
  /// 백엔드 팀과 URL 및 HTTP 메서드 확인 필요
  Future<void> updatePassword(String newPassword) async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');

    // TODO: URL 경로 확인 필요
    final url = Uri.parse('${Constants.baseUrl}/users/me/password');
    final response = await client.put(  // PUT 메서드로 변경
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'password': newPassword}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == '비밀번호 수정 성공') {
        return;
      }
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (response.statusCode == 400) {
      final message = jsonDecode(response.body)['message'];
      throw Exception(message ?? '비밀번호 형식이 올바르지 않습니다.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 오류가 발생했습니다.');
    }
    
    throw Exception('비밀번호 수정 실패: ${response.body}');
  }

  /// 사용자의 닉네임을 최초 저장하거나 수정하는 메서드
  /// 
  /// [nickname] 설정할 닉네임
  /// 
  /// 성공 시 저장된 닉네임 반환
  /// 실패 시 적절한 에러 메시지와 함께 예외 발생
  Future<String> changeNickName(String nickname) async {
    // TEST BYPASS: 디자인 플로우용 test 닉네임은 서버 호출 없이 통과
    // TODO(prod): 배포 전 제거 또는 feature flag 적용
    if (nickname == Constants.testLoginId && Constants.enableLocalTestBypass) {
      return Constants.testLoginId;
    }

    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');

    final url = Uri.parse('${Constants.baseUrl}/users/save-nickname');
    final response = await client.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // TODO(custom-header): 확정되면 X-Custom-User-Id 적용
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == '닉네임 최초 저장 및 수정 완료') {
        return data['nickname'];
      }
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (response.statusCode == 400) {
      throw Exception('닉네임은 공백일 수 없습니다.');
    } else if (response.statusCode == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (response.statusCode == 500) {
      throw Exception('서버 오류가 발생했습니다.');
    }
    
    throw Exception('닉네임 저장/수정 실패: ${response.body}');
  }

  Future<void> deleteAccount() async {
    final token = await authRepository.getToken();
    if (token == null) throw Exception('JWT 토큰이 없습니다.');
    final url = Uri.parse('${Constants.baseUrl}/users/delete');
    final response = await client.delete(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete account: ${response.body}');
    }
  }
}
