import 'package:data/models/user_model.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:data/constants.dart';
import 'package:domain/entities/user.dart';
import 'package:injectable/injectable.dart';

// Cookie 기반 인증 대응을 위해 http.Client -> Dio 전환
// - Authorization 헤더는 쿠키가 이미 세션을 대표하면 선택적 (fallback)
// - TOKEN_EXPIRED 등은 전역 Dio 인터셉터(dio_client.dart)에서 처리
// TODO(user): 엔드포인트 prefix '/api/v1' 적용 여부 재확인 후 경로 조정

@LazySingleton()
class UserRemoteDatasource {
  final Dio dio;
  final AuthRepository authRepository;
  UserRemoteDatasource(this.dio, this.authRepository);


  Future<User> getUserMe() async {
    // 쿠키 세션 기반 우선 호출; 토큰이 있으면 Authorization 헤더를 보조로 추가
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    // Bearer 헤더는 body 토큰을 받은 경우에만 부착 (쿠키 기반이면 생략)
    if (token != null && token.contains('.')) {
      headers['Authorization'] = 'Bearer $token';
    }
    final path = '/users/me'; // TODO(user-endpoint): '/api/v1/users/me' 확인 후 변경
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
  /// 
  /// URL 옵션들:
  /// - 현재 구현: `/users/me/password` (PATCH)
  /// - API 문서: `/users/update-password` (PUT)
  /// 
  /// 백엔드 팀과 URL 및 HTTP 메서드 확인 필요
  Future<void> updatePassword(String newPassword) async {
  final token = await authRepository.getToken();
  final headers = <String, String>{'Content-Type': 'application/json'};
  if (token != null && token.contains('.')) headers['Authorization'] = 'Bearer $token';
    final path = '/users/me/password'; // TODO(user-endpoint): prefix 확인
    final resp = await dio.put(path,
        data: {'password': newPassword},
        options: Options(headers: headers));
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
      throw Exception('서버 오류가 발생했습니다.');
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
  if (token != null && token.contains('.')) headers['Authorization'] = 'Bearer $token';
    // 다중 엔드포인트 후보 (스펙 확정 전 임시): prefix 포함/미포함 + HTTP 메서드 PUT/PATCH
    final candidates = <({String method, String path})>[
      (method: 'PUT', path: '/api/v1/users/save-nickname'),
      (method: 'PUT', path: '/users/save-nickname'),
      (method: 'PATCH', path: '/api/v1/users/save-nickname'),
      (method: 'PATCH', path: '/users/save-nickname'),
    ];

    Response? resp;
  // NOTE: 최종 후보까지 모두 실패했을 때 디버깅 용 여유 변수 (현재 로직상 미사용)
  // DioException? lastError; // 필요 시 로깅 활성화
    for (final c in candidates) {
      try {
        if (c.method == 'PUT') {
          resp = await dio.put(c.path,
              data: {'nickname': nickname}, options: Options(headers: headers));
        } else {
          resp = await dio.patch(c.path,
              data: {'nickname': nickname}, options: Options(headers: headers));
        }
        final status = resp.statusCode ?? 0;
        if (status == 401 && resp.data is Map && resp.data['errorCode'] == 'TOKEN_EXPIRED') {
          // 인터셉터가 재시도하기 전 원본 요청을 재발행하지 않도록 대기 후 재시도 큐 처리 기다림
          // 여기서는 단순히 다음 후보를 시도하지 않고 break 해서 아래 status 처리
        }
        if (status == 404) {
          // 경로 문제일 가능성: 다음 후보 시도
          continue;
        }
        // 200 / 400 / 500 / 401(TOKEN_EXPIRED 재시도 후 실패) 등 처리 위해 break
        break;
      } on DioException catch (_) {
        continue; // 다음 후보 시도
      }
    }
    if (resp == null) {
      throw Exception('닉네임 저장 요청 실패 (엔드포인트 미응답)');
    }
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final data = resp.data;
      if (data is Map && data['message'] == '닉네임 최초 저장 및 수정 완료') {
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
  if (token != null && token.contains('.')) headers['Authorization'] = 'Bearer $token'; // Bearer 통일 (유효 토큰일 때만)
    final path = '/users/delete';
    final resp = await dio.delete(path, options: Options(headers: headers));
    if ((resp.statusCode ?? 0) != 200) {
      throw Exception('Failed to delete account: ${resp.data}');
    }
  }
}
