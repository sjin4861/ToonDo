import 'package:domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
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
  final Dio dio;
  final AuthRepository authRepository;

  TodoRemoteDataSource(this.dio, this.authRepository);

  Future<String> createTodo({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    int? goalId,
    required String eisenhower,
    bool showOnHome = false,
  }) async {
  final options = await _authOptions();

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
      "showOnHome": showOnHome,
    };

    final resp = await dio.post('/api/v1/todos', data: requestBody, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200 || status == 201) {
      final body = resp.data;
      if (body is Map && body.containsKey('todoId')) {
        return body['todoId'].toString();
      }
      throw Exception('투두 생성 응답 형식 오류: ${resp.data}');
    } else if (status == 400) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Bad Request') : 'Bad Request';
      throw Exception('서버 응답 400: $msg');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to create todo: $status');
  }

  Future<Map<String, List<Todo>>> fetchTodosByDate(DateTime date) async {
    final options = await _authOptions();

    final dateString = date.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
    final resp = await dio.get('/api/v1/by-date', queryParameters: {'date': dateString}, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final decoded = resp.data;
      if (decoded is Map) {
        final List<dynamic> ddayJson = decoded['dday'] ?? [];
        final List<Todo> ddayTodos = ddayJson.map((json) {
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
            comment: '',
            showOnHome: json['showOnHome'] as bool? ?? false,
          );
        }).toList();
        final List<dynamic> dailyJson = decoded['daily'] ?? [];
        final List<Todo> dailyTodos = dailyJson.map((json) {
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
            comment: '',
            showOnHome: json['showOnHome'] as bool? ?? false,
          );
        }).toList();
        return {'dday': ddayTodos, 'daily': dailyTodos};
      }
      throw Exception('날짜별 투두 응답 형식 오류: ${resp.data}');
    } else if (status == 400) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Bad Request') : 'Bad Request';
      throw Exception('서버 응답 400: $msg');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to fetch todos by date: $status');
  }

  Future<List<Todo>> fetchTodosByGoal(int goalId) async {
    final options = await _authOptions();

    final resp = await dio.get('/api/v1/todos/by-goal/$goalId', options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final decoded = resp.data;
      if (decoded is Map) {
        final List<dynamic> dataJson = decoded['data'] ?? [];
        final List<Todo> todos = dataJson.map((json) {
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
            comment: '',
            showOnHome: json['showOnHome'] as bool? ?? false,
          );
        }).toList();
        return todos;
      }
      throw Exception('목표별 투두 응답 형식 오류: ${resp.data}');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to fetch todos by goal: $status');
  }

  Future<Todo> fetchTodoById(int todoId) async {
    final options = await _authOptions();

    final resp = await dio.get('/api/v1/todos/$todoId', options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final decoded = resp.data;
      if (decoded is Map) {
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
          comment: '',
          showOnHome: json['showOnHome'] as bool? ?? false,
        );
      }
      throw Exception('투두 ID별 조회 응답 형식 오류: ${resp.data}');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to fetch todo by id: $status');
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
  final options = await _authOptions();

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
      "showOnHome": showOnHome,
    };

    final resp = await dio.put('/api/v1/todos/$todoId', data: requestBody, options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final body = resp.data;
      if (body is Map && body.containsKey('todoId')) {
        return body['todoId'].toString();
      }
      throw Exception('투두 업데이트 응답 형식 오류: ${resp.data}');
    } else if (status == 400) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Bad Request') : 'Bad Request';
      throw Exception('서버 응답 400: $msg');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to update todo: $status');
  }

  Future<Map<String, dynamic>> toggleTodoStatus(int todoId) async {
    final options = await _authOptions();

    final resp = await dio.patch('/api/v1/todos/$todoId/status', options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      final decoded = resp.data;
      if (decoded is Map) {
        return {
          'todoId': decoded['todoId'],
          'status': decoded['status'],
          'completedAt': decoded['completedAt'],
        };
      }
      throw Exception('투두 상태 토글 응답 형식 오류: ${resp.data}');
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    } else if (status == 500) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Internal Server Error') : 'Internal Server Error';
      throw Exception('서버 응답 500: $msg');
    }
    throw Exception('Failed to toggle todo status: $status');
  }

  Future<bool> deleteTodo(int todoId) async {
    final options = await _authOptions();

    final resp = await dio.delete('/api/v1/todos/$todoId', options: options);
    final status = resp.statusCode ?? 0;
    if (status == 200) {
      return true;
    } else if (status == 404) {
      final msg = (resp.data is Map) ? (resp.data['message'] ?? 'Not Found') : 'Not Found';
      throw Exception('서버 응답 404: $msg');
    }
    throw Exception('Failed to delete todo: $status');
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
  Future<Options> _authOptions() async {
    final token = await authRepository.getToken();
    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
    if (token != null && _looksLikeJwt(token)) {
      headers['Authorization'] = token.startsWith('Bearer') ? token : 'Bearer $token';
    }
    return Options(headers: headers);
  }

  bool _looksLikeJwt(String token) => RegExp(r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$').hasMatch(token.replaceFirst('Bearer ', ''));
}
