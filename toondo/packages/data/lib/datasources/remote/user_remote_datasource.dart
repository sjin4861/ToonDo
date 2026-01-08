import 'package:data/models/user_model.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:data/constants.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';

// Cookie 기반 인증 대응을 위해 http.Client -> Dio 전환
// - Authorization 헤더는 쿠키가 이미 세션을 대표하면 선택적 (fallback)
// - TOKEN_EXPIRED 등은 전역 Dio 인터셉터(dio_client.dart)에서 처리
// NOTE: 현재는 API 명세서 기준으로 '/api/v1' prefix를 사용

@LazySingleton()
class UserRemoteDatasource {
  final Dio dio;
  final AuthRepository authRepository;
  UserRemoteDatasource(this.dio, this.authRepository);

  Future<User> getUserMe() async {
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.contains('.')) {
      headers['Authorization'] = 'Bearer $token';
    }
    final path = '/api/v1/users/me';
    Response resp;
    try {
      resp = await dio.get(path, options: Options(headers: headers));
    } catch (e) {
      rethrow;
    }
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      if (data is Map && data['message'] == '내 정보 조회 성공') {
        return UserModel.fromJson(Map<String, dynamic>.from(data)).toEntity();
      }
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (status == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (status == 500) {
      throw Exception('서버 오류가 발생했습니다.');
    }
    throw Exception('내 정보 조회 실패: ${resp.data}');
  }

  /// 사용자의 비밀번호를 수정하는 메서드
  /// API 명세: `PUT /api/v1/users/me/password`
  Future<void> updatePassword(String newPassword) async {
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.contains('.')) {
      headers['Authorization'] = 'Bearer $token';
    }
    final path = '/api/v1/users/me/password';
    final resp = await dio.put(
      path,
      data: {'password': newPassword},
      options: Options(headers: headers),
    );
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      if (data is Map && data['message'] == '비밀번호 수정 성공') return;
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (status == 400) {
      String? message;
      final body = resp.data;
      if (body is Map) message = body['message'] as String?;
      throw Exception(message ?? '비밀번호 형식이 올바르지 않습니다.');
    } else if (status == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (status == 500) {
      throw Exception('서버 오류가 발생했습니다: ${resp.data}');
    }
    throw Exception('비밀번호 수정 실패: ${resp.data}');
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
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.contains('.'))
      headers['Authorization'] = 'Bearer $token';

    final resp = await dio.patch(
      '/api/v1/users/save-nickname',
      data: {'nickname': nickname},
      options: Options(headers: headers),
    );
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      if (data is Map && data['message'] == '닉네임 최초 저장 및 수정 성공') {
        return data['nickname'] as String? ?? '';
      }
      throw Exception('응답 형식이 올바르지 않습니다.');
    } else if (status == 400) {
      throw Exception('닉네임은 공백일 수 없습니다.');
    } else if (status == 401) {
      if (resp.data is Map && resp.data['errorCode'] == 'TOKEN_EXPIRED') {
        throw Exception('세션이 만료되었습니다. 다시 로그인 해주세요.');
      }
      throw Exception('인증에 실패했습니다. (401)');
    } else if (status == 404) {
      throw Exception('사용자를 찾을 수 없습니다.');
    } else if (status == 500) {
      throw Exception('서버 오류가 발생했습니다.');
    }
    throw Exception('닉네임 저장/수정 실패: ${resp.data}');
  }

  Future<void> deleteAccount() async {
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.contains('.'))
      headers['Authorization'] = 'Bearer $token'; // Bearer 통일 (유효 토큰일 때만)
    final path = '/users/delete';
    final resp = await dio.delete(path, options: Options(headers: headers));
    if ((resp.statusCode ?? 0) != 200) {
      throw Exception('Failed to delete account: ${resp.data}');
    }
  }
}
