import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:toondo/constants.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/services/auth_service.dart';
import 'package:toondo/services/user_service.dart';

class TodoService {
  final String baseUrl = Constants.baseUrl;
  final http.Client httpClient = http.Client();
  final Box<Todo> _todoBox;
  final AuthService authService = AuthService();
  final UserService userService;

  /// 로컬에서 삭제한 투두 ID를 임시 보관하는 리스트
  /// (동기화 시 `deletedTodoIds`로 서버에 전송)
  final List<String> _deletedIds = [];

  TodoService(this._todoBox, this.userService);

  /// -----------------------------
  /// 1) 로컬 Hive CRUD 메서드들
  /// -----------------------------

  /// 모든 투두를 로드
  Future<List<Todo>> loadTodoList() async {
    return _todoBox.values.toList();
  }

  /// 로컬 Box를 비우고 새 투두들로 덮어쓰기
  Future<void> saveTodoList(List<Todo> todos) async {
    try {
      await _todoBox.clear();
      final Map<String, Todo> todoMap = {for (var t in todos) t.id: t};
      await _todoBox.putAll(todoMap);
    } catch (e) {
      print('Error saving todo list: $e');
      rethrow;
    }
  }

  /// 투두 추가
  Future<void> addTodo(Todo todo) async {
    try {
      await _todoBox.put(todo.id, todo);
    } catch (e) {
      print('Error adding todo: $e');
      rethrow;
    }
  }

  /// 투두 수정
  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      updatedTodo.isSynced = false;
      await updatedTodo.save();
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
  }

  /// 투두 진행률 수정
  Future<void> updateTodoStatus(String todoId, double status) async {
    try {
      final todo = _todoBox.get(todoId);
      if (todo != null) {
        todo.status = status;
        todo.isSynced = false;
        await todo.save();
      }
    } catch (e) {
      print('Error updating todo status: $e');
      rethrow;
    }
  }

  /// 투두 날짜 수정
  Future<void> updateTodoDates(Todo todo) async {
    try {
      todo.isSynced = false;
      await todo.save();
    } catch (e) {
      print('Error updating todo dates: $e');
      rethrow;
    }
  }

  /// 투두 삭제 (로컬Box + _deletedIds에 기록)
  Future<void> deleteTodoById(String id) async {
    try {
      // 먼저 로컬에서 실제 삭제
      await _todoBox.delete(id);
      // 서버에 삭제를 알려줄 수 있도록 _deletedIds에 보관
      _deletedIds.add(id);
    } catch (e) {
      print('Error deleting todo with id $id: $e');
      rethrow;
    }
  }

  /// 특정 투두 반환
  Todo? getTodoById(String id) {
    return _todoBox.get(id);
  }

  /// -----------------------------
  /// 2) 서버 연동: sync / commit
  /// -----------------------------

  /// (A) syncTodos()
  /// POST /todos/all/fetch
  /// - 미동기화 투두들(생성·수정) -> toDoRequests
  /// - 삭제된 투두 ID -> deletedTodoIds
  /// - 서버에서 처리 후, 응답 200 -> isSynced=true
  Future<void> commitTodos() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    // 1) 미동기화된 투두 수집
    final unsyncedTodos = _todoBox.values.where((t) => !t.isSynced).toList();

    // 2) toDoRequests 생성, id와 goalId를 서버 스펙에 맞게 Long (int) 타입으로 변환
    final toDoRequests = unsyncedTodos.map((t) {
      return {
        "todoId": int.parse(t.id),
        "goalId": t.goalId != null ? int.parse(t.goalId!) : null,
        "title": t.title,
        "status": t.status,
        "startDate": t.startDate.toIso8601String().split('T')[0],
        "endDate": t.endDate.toIso8601String().split('T')[0],
        "urgency": t.urgency,
        "importance": t.importance,
        "comment": t.comment.isEmpty ? null : t.comment,
      };
    }).toList();

    // 3) deletedTodoIds: 로컬에서 삭제된 ID
    final List<String> deletedTodoIds = _deletedIds;

    final requestBody = {
      "toDoRequests": toDoRequests,
      "deletedTodoIds": deletedTodoIds,
    };
    print(requestBody);

    final url = Uri.parse('$baseUrl/todos/all/commit');
    try {
      final response = await httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Response Status Code : ${response.statusCode}');
      if (response.statusCode == 200) {
        // 예) {"message":"투두 동기화 성공","savedTodosCount":2,"deletedCount":3}
        final decoded = jsonDecode(response.body);
        print('동기화 성공: ${decoded['message']}');

        // 미동기화 투두들 -> isSynced = true
        for (var todo in unsyncedTodos) {
          todo.isSynced = true;
          await todo.save();
        }

        // 삭제 처리가 끝났으니 _deletedIds 정리
        for (final del in _deletedIds) {
          // 로컬에 이미 deleteTodoById()로 삭제완료
          // 서버에도 반영됐으니 OK
        }
        _deletedIds.clear();
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'] ?? 'Bad Request';
        throw Exception('서버 응답 400: $errMsg');
      } else {
        throw Exception('Failed to commit todos: ${response.body}');
      }
    } catch (e) {
      print('Error commit todos: $e');
      rethrow;
    }
  }

  /// (B) commitTodos()
  /// GET /todos/all/commit
  /// - 서버가 해당 유저의 모든 투두를 반환
  /// - 200 -> "todos": [...] 을 로컬에 저장 (전체 갱신)
  /// - 404 -> "해당 유저의 투두 리스트가 없습니다." -> 로컬 clear()
  Future<void> fetchTodos() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    final url = Uri.parse('$baseUrl/todos/all/fetch');

    try {
      final response = await httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        /* 예시 응답
        {
          "message": "유저 투두리스트 전체 조회 성공",
          "todos": [
            { "todoId":1, "goalId":3, ... },
            { "todoId":2, "goalId":null, ... }
          ],
          "count": 2
        }
        */
        final decoded = jsonDecode(response.body);
        final message = decoded['message'];
        final List<dynamic> todosJson = decoded['todos'];
        final count = decoded['count'];

        print('$message (count=$count)');

        // title을 utf8 디코딩하여 처리
        final List<Todo> newList = todosJson.map((json) {
          final String todoId = json['todoId'].toString();
          final dynamic goalIdValue = json['goalId'];
          final String title = utf8.decode(json['title'].toString().codeUnits);
          return Todo(
            id: todoId,
            goalId: goalIdValue != null ? goalIdValue.toString() : null,
            title: title,
            status: (json['status'] as num).toDouble(),
            startDate: DateTime.parse(json['startDate']),
            endDate: DateTime.parse(json['endDate']),
            urgency: json['urgency'] as int,
            importance: json['importance'] as int,
            comment: json['comment'] ?? '',
            isSynced: true, // 서버가 최신이므로 true
          );
        }).toList();

        // 로컬 덮어쓰기
        await _todoBox.clear();
        final Map<String, Todo> todoMap = {for (var t in newList) t.id: t};
        await _todoBox.putAll(todoMap);
      } else if (response.statusCode == 404) {
        // {"message":"해당 유저의 투두 리스트가 없습니다."}
        final decoded = jsonDecode(response.body);
        final errMsg = decoded['message'];
        print('서버 응답 404: $errMsg');
        // 로컬 투두도 비울지 결정
        await _todoBox.clear();
      } else {
        throw Exception('Failed to fetch todos: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchTodos: $e');
      rethrow;
    }
  }
  // 임시 코드
  Future<int> getUnsyncedTodosCount() async {return 0;}
}
