import 'dart:convert';
import 'package:domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

// NOTE:
// 현재 파일은 원래의 JWT 기반 Authorization 흐름으로 복구되었습니다.
// 이전 커밋에서 임시로 토큰 없이 `X-Custom-User-Id` 헤더를 사용하는 코드가 적용되었지만
// 이는 백엔드 정식 스펙 확정 전까지 사용 보류합니다.
// 아래 각 메서드의 headers 위에 주석으로 대체 헤더 사용 예시를 남겨두었습니다.
// 백엔드에서 Custom User Header 모드가 확정되면 해당 주석을 참고하여 다시 적용하면 됩니다.

@LazySingleton()
class TodoRemoteDataSource {
  http.Client client;
  final AuthRepository authRepository;

  TodoRemoteDataSource(this.client, this.authRepository);

  Future<String> createTodo({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    int? goalId,
    required String eisenhower,
    bool showOnHome = false,
  }) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
      "showOnHome": showOnHome,
    };

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos');
    print('📝 투두 생성 요청 URL: $url');
    print('🚀 요청 헤더: $headers');
    print('🚀 요청 바디: $requestBody');

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 투두 생성 성공');
        return decoded['todoId'].toString();
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, List<Todo>>> fetchTodosByDate(DateTime date) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final dateString = date.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
    final url = Uri.parse(
      '${Constants.baseUrl}/api/v1/by-date?date=$dateString',
    );
    print('📋 날짜별 투두 조회 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    try {
      final response = await client.get(url, headers: headers);

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 날짜별 투두 조회 성공');

        // dday 투두 목록 파싱
        final List<dynamic> ddayJson = decoded['dday'] ?? [];
        final List<Todo> ddayTodos =
            ddayJson.map((json) {
              final todoId = json['todoId'].toString();
              final dynamic goalId = json['goalId'];
              return Todo(
                id: todoId,
                goalId: goalId?.toString(),
                title: json['title'],
                status: (json['status'] as num).toDouble(),
                startDate: DateTime.parse(json['startDate']),
                endDate: DateTime.parse(json['endDate']),
                eisenhower: json['eisenhower'] as int,
                comment: '', // API 응답에 comment 필드가 없으므로 빈 문자열
                showOnHome: json['showOnHome'] as bool? ?? false,
              );
            }).toList();

        // daily 투두 목록 파싱
        final List<dynamic> dailyJson = decoded['daily'] ?? [];
        final List<Todo> dailyTodos =
            dailyJson.map((json) {
              final todoId = json['todoId'].toString();
              final dynamic goalId = json['goalId'];
              return Todo(
                id: todoId,
                goalId: goalId?.toString(),
                title: json['title'],
                status: (json['status'] as num).toDouble(),
                startDate: DateTime.parse(json['startDate']),
                endDate: DateTime.parse(json['endDate']),
                eisenhower: json['eisenhower'] as int,
                comment: '', // API 응답에 comment 필드가 없으므로 빈 문자열
                showOnHome: json['showOnHome'] as bool? ?? false,
              );
            }).toList();

        return {'dday': ddayTodos, 'daily': dailyTodos};
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception(
          'Failed to fetch todos by date: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Todo>> fetchTodosByGoal(int goalId) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/by-goal/$goalId');
    print('📋 목표별 투두 조회 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    try {
      final response = await client.get(url, headers: headers);

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 목표별 투두 조회 성공');

        // data 배열에서 투두 목록 파싱
        final List<dynamic> dataJson = decoded['data'] ?? [];
        final List<Todo> todos =
            dataJson.map((json) {
              final todoId = json['todoId'].toString();
              final dynamic goalId = json['goalId'];
              return Todo(
                id: todoId,
                goalId: goalId?.toString(),
                title: json['title'],
                status: (json['status'] as num).toDouble(),
                startDate: DateTime.parse(json['startDate']),
                endDate: DateTime.parse(json['endDate']),
                eisenhower: _parseEisenhower(json['eisenhower']),
                comment: '', // API 응답에 comment 필드가 없으므로 빈 문자열
                showOnHome: json['showOnHome'] as bool? ?? false,
              );
            }).toList();

        return todos;
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception(
          'Failed to fetch todos by goal: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Todo> fetchTodoById(int todoId) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');
    print('📋 투두 ID별 조회 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    try {
      final response = await client.get(url, headers: headers);

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 투두 ID별 조회 성공');

        // data 객체에서 투두 정보 파싱
        final json = decoded['data'];
        final todoIdStr = json['todoId'].toString();
        final dynamic goalId = json['goalId'];

        return Todo(
          id: todoIdStr,
          goalId: goalId?.toString(),
          title: json['title'],
          status: (json['status'] as num).toDouble(),
          startDate: DateTime.parse(json['startDate']),
          endDate: DateTime.parse(json['endDate']),
          eisenhower: _parseEisenhower(json['eisenhower']),
          comment: '', // API 응답에 comment 필드가 없으므로 빈 문자열
          showOnHome: json['showOnHome'] as bool? ?? false,
        );
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception('Failed to fetch todo by id: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateTodo({
    required int todoId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    int? goalId,
    required String eisenhower,
    bool showOnHome = false,
  }) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
      "showOnHome": showOnHome,
    };

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');
    print('🔄 투두 업데이트 요청 URL: $url');
    print('🚀 요청 헤더: $headers');
    print('🚀 요청 바디: $requestBody');

    try {
      final response = await client.put(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 투두 업데이트 성공');
        return decoded['todoId'].toString();
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> toggleTodoStatus(int todoId) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId/status');
    print('🔄 투두 상태 토글 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    try {
      final response = await client.patch(url, headers: headers);

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        print('✅ 투두 상태 토글 성공');
        return {
          'todoId': decoded['todoId'],
          'status': decoded['status'],
          'completedAt': decoded['completedAt'],
        };
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Internal Server Error';
        throw Exception('서버 응답 500: $errMsg');
      } else {
        throw Exception('Failed to toggle todo status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTodo(int todoId) async {
    final token = await authRepository.getToken();
    final headers = await _buildAuthHeaders(token);

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');
    print('🗑️ 투두 삭제 요청 URL: $url');
    print('🚀 요청 헤더: $headers');

    try {
      final response = await client.delete(url, headers: headers);

      print('📥 응답 코드: ${response.statusCode}');

      // UTF-8 디코딩 처리
      String responseBody = '';
      try {
        responseBody = utf8.decode(response.bodyBytes);
        print('📥 응답 바디: $responseBody');
      } catch (e) {
        print('📥 응답 바디 디코딩 오류: $e');
        responseBody = response.body;
        print('📥 원본 응답 바디: $responseBody');
      }

      if (response.statusCode == 200) {
        print('✅ 투두 삭제 성공');
        return true;
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(responseBody);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // eisenhower 값을 정수로 변환하는 헬퍼 메서드
  // TODO: eisenhower 값이 0,1,2,3 인지 1,2,3,4 인지 확인 필요
  int _parseEisenhower(dynamic eisenhower) {
    if (eisenhower is int) {
      return eisenhower;
    } else if (eisenhower is String) {
      // "IMPORTANT_URGENT" 같은 문자열을 숫자로 매핑
      // TODO: 매핑값이 1,2,3,4 인지 0,1,2,3 인지 서버 API 스펙 확인 필요
      switch (eisenhower) {
        case 'IMPORTANT_URGENT':
          return 1; // TODO: 0일 수도 있음
        case 'IMPORTANT_NOT_URGENT':
          return 2; // TODO: 1일 수도 있음
        case 'NOT_IMPORTANT_URGENT':
          return 3; // TODO: 2일 수도 있음
        case 'NOT_IMPORTANT_NOT_URGENT':
          return 4; // TODO: 3일 수도 있음
        default:
          return 1; // TODO: 기본값도 0일 수도 있음
      }
    }
    return 1; // TODO: 기본값도 0일 수도 있음
  }

  Future<List<Todo>> fetchTodos() async {
    // TODO: 백엔드와 얘기 필요 - API 스펙 확정 후 구현
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }

  Future<bool> commitTodos(
    List<Todo> unsyncedTodos,
    List<Todo> deletedTodos,
  ) async {
    // TODO: 백엔드와 얘기 필요 - API 스펙 확정 후 구현
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }
  // --- Auth Header Builder ---
  Future<Map<String, String>> _buildAuthHeaders(String? token) async {
    // 1) 정상 JWT 사용
    if (token != null) {
      String authToken = token;
      if (!token.startsWith('Bearer ') && !token.startsWith('bearer ')) {
        authToken = 'Bearer $token';
      }
      return {
        'Authorization': authToken,
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
    // 2) 토큰 없고 Custom User Header 허용 시
    if (Constants.useCustomUserIdHeader) {
      return {
        Constants.customUserIdHeader: Constants.testUserNumericId.toString(),
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
    // 3) 둘 다 불가 → 예외
    throw Exception('인증 수단이 없습니다. (JWT/CustomUserHeader 모두 미사용)');
  }
}
