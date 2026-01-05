import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:data/constants.dart';

/// 간단한 Route → Response 매핑을 관리하는 레지스트리
/// 실서비스 API 문서와 맞춰 필요한 경우 지속적으로 확장한다.
class MockResponseRegistry {
  MockResponseRegistry();

  static final Map<_MockRoute, Response<dynamic>> _routes = {
    _MockRoute(method: 'POST', pathMatcher: '/api/v1/users/signup'): Response(
      requestOptions: RequestOptions(path: '/api/v1/users/signup'),
      statusCode: 201,
      data: const {
        'accessToken': 'MOCK_ACCESS_TOKEN',
        'message': '[MOCK] 회원가입 성공',
      },
    ),
    _MockRoute(method: 'POST', pathMatcher: '/users/signup'): Response(
      requestOptions: RequestOptions(path: '/users/signup'),
      statusCode: 201,
      data: const {
        'accessToken': 'MOCK_ACCESS_TOKEN',
        'message': '[MOCK] 회원가입 성공',
      },
    ),
    _MockRoute(
      method: 'GET',
      pathMatcher: '/api/v1/users/check-loginid',
      queryContains: {'loginId', 'loginid'},
    ): Response(
      requestOptions: RequestOptions(path: '/api/v1/users/check-loginid'),
      statusCode: 200,
      data: const {
        'exists': false,
        'message': '[MOCK] 사용 가능한 아이디입니다.',
      },
    ),
    _MockRoute(
      method: 'GET',
      pathMatcher: '/users/check-loginid',
      queryContains: {'loginId', 'loginid'},
    ): Response(
      requestOptions: RequestOptions(path: '/users/check-loginid'),
      statusCode: 200,
      data: const {
        'exists': false,
        'message': '[MOCK] 사용 가능한 아이디입니다.',
      },
    ),
    _MockRoute(
      method: 'PUT',
      pathMatcher: '/api/v1/users/save-nickname',
    ): Response(
      requestOptions: RequestOptions(path: '/api/v1/users/save-nickname'),
      statusCode: 200,
      data: const {
        'message': '[MOCK] 닉네임 최초 저장 및 수정 완료',
        'nickname': '테스트 슬라임',
      },
    ),
    _MockRoute(
      method: 'PUT',
      pathMatcher: '/users/save-nickname',
    ): Response(
      requestOptions: RequestOptions(path: '/users/save-nickname'),
      statusCode: 200,
      data: const {
        'message': '[MOCK] 닉네임 최초 저장 및 수정 완료',
        'nickname': '테스트 슬라임',
      },
    ),
    _MockRoute(method: 'POST', pathMatcher: '/api/v1/login'): Response(
      requestOptions: RequestOptions(path: '/api/v1/login'),
      statusCode: 200,
      data: const {
        'accessToken': 'MOCK_ACCESS_TOKEN',
        'message': '[MOCK] 로그인 성공',
      },
    ),
    _MockRoute(method: 'POST', pathMatcher: '/api/v1/users/login'): Response(
      requestOptions: RequestOptions(path: '/api/v1/users/login'),
      statusCode: 200,
      data: const {
        'accessToken': 'MOCK_ACCESS_TOKEN',
        'message': '[MOCK] 로그인 성공',
      },
    ),
    _MockRoute(method: 'POST', pathMatcher: '/users/login'): Response(
      requestOptions: RequestOptions(path: '/users/login'),
      statusCode: 200,
      data: const {
        'accessToken': 'MOCK_ACCESS_TOKEN',
        'message': '[MOCK] 로그인 성공',
      },
    ),
  };

  Response<dynamic>? find(RequestOptions request) {
    final key = _MockRoute(
      method: request.method,
      pathMatcher: request.path,
      queryContains: request.queryParameters.keys.toSet(),
    );
    for (final route in _routes.keys) {
      if (route.matches(key)) {
        // 요청별로 deep copy 필요 시 clone 로직 추가
        final response = _routes[route]!;
        return response.copyWith(
          requestOptions: request,
        );
      }
    }
    return null;
  }
}

class _MockRoute {
  final String method;
  final String pathMatcher;
  final Set<String>? queryContains;

  const _MockRoute({
    required this.method,
    required this.pathMatcher,
    this.queryContains,
  });

  bool matches(_MockRoute other) {
    final sameMethod = method.toUpperCase() == other.method.toUpperCase();
    if (!sameMethod) return false;
    final samePath = other.pathMatcher.contains(pathMatcher) ||
        pathMatcher.contains(other.pathMatcher);
    if (!samePath) return false;
    if (queryContains == null) return true;
    if (other.queryContains == null) return false;
    return queryContains!.any(other.queryContains!.contains);
  }
}

extension on Response<dynamic> {
  Response<dynamic> copyWith({
    RequestOptions? requestOptions,
    int? statusCode,
    dynamic data,
  }) {
    return Response(
      requestOptions: requestOptions ?? this.requestOptions,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }
}
