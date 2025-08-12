import 'dart:convert';
import 'package:domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:data/constants.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

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
  }) async {
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
    };

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos');
    try {
      final response = await client.post(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['todoId'].toString();
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final dateString = date.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
    final url = Uri.parse(
      '${Constants.baseUrl}/api/v1/by-date?date=$dateString',
    );

    try {
      final response = await client.get(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

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
              );
            }).toList();

        return {'dday': ddayTodos, 'daily': dailyTodos};
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/by-goal/$goalId');

    try {
      final response = await client.get(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

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
              );
            }).toList();

        return todos;
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');

    try {
      final response = await client.get(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

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
        );
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
  }) async {
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final requestBody = {
      "title": title,
      "startDate": startDate.toIso8601String().split('T')[0],
      "endDate": endDate.toIso8601String().split('T')[0],
      "goalId": goalId,
      "eisenhower": eisenhower,
    };

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');
    try {
      final response = await client.put(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['todoId'].toString();
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId/status');

    try {
      final response = await client.patch(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {
          'todoId': decoded['todoId'],
          'status': decoded['status'],
          'completedAt': decoded['completedAt'],
        };
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Not Found';
        throw Exception('서버 응답 404: $errMsg');
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
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
    // TODO: 임시로 X-Custom-User-Id 헤더 사용 (auth 시스템이 준비되면 JWT로 변경)
    // final token = await authRepository.getToken();
    // if (token == null) {
    //   throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    // }

    // 토큰에 이미 Bearer 접두사가 있는지 확인
    // final String authHeader =
    //     token.startsWith('Bearer ') ? token : 'Bearer $token';

    final url = Uri.parse('${Constants.baseUrl}/api/v1/todos/$todoId');

    try {
      final response = await client.delete(
        url,
        headers: {
          'X-Custom-User-Id': '15', // 임시 사용자 ID
          // 'Authorization': authHeader, // JWT 사용 시 활성화
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
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
}
