// lib/services/todo_service.dart

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:todo_with_alarm/constants.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/auth_service.dart';
import 'package:todo_with_alarm/services/user_service.dart';

class TodoService {
  final String baseUrl = Constants.baseUrl;
  final http.Client httpClient = http.Client();
  final Box<Todo> _todoBox;
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  /// 생성자를 통해 Hive 박스를 주입받습니다.
  TodoService(this._todoBox);

  /// 모든 투두를 저장하는 메서드
  /// 기존 데이터를 모두 삭제한 후 새로운 투두 리스트를 저장합니다.
  Future<void> saveTodoList(List<Todo> todos) async {
    try {
      await _todoBox.clear(); // 기존 데이터를 모두 삭제

      // todo.id를 키로 사용하여 여러 개의 투두를 한 번에 저장
      final Map<String, Todo> todoMap = {for (var todo in todos) todo.id: todo};
      await _todoBox.putAll(todoMap);
    } catch (e) {
      print('Error saving todo list: $e');
      rethrow; // 에러를 다시 던져 호출자에게 전달
    }
  }

  /// 모든 투두를 로드하는 메서드
  Future<List<Todo>> loadTodoList() async {
    try {
      return _todoBox.values.toList();
    } catch (e) {
      print('Error loading todo list: $e');
      rethrow;
    }
  }

  // 특정 투두를 수정하는 메서드
  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      updatedTodo.isSynced = false; // 동기화되지 않은 상태로 변경
      await updatedTodo.save(); // HiveObject의 save 메서드 사용
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
  }

  /// 특정 투두의 진행률을 업데이트하는 메서드
  Future<void> updateTodoStatus(String todoId, double status) async {
    try {
      Todo? todo = _todoBox.get(todoId);
      if (todo != null) {
        todo.status = status;
        await todo.save(); // HiveObject의 save 메서드 사용
      } else {
        print('Todo with id $todoId not found.');
      }
    } catch (e) {
      print('Error updating todo status: $e');
      rethrow;
    }
  }

  /// 특정 투두를 삭제하는 메서드
  /// 이렇게 되었을 때 서버에서도 삭제해야할까?? (지윤님과 상의 필요)
  /// 내가 편한건 커밋해서 없는 투두는 그냥 삭제하는건데
  Future<void> deleteTodoById(String id) async {
    try {
      await _todoBox.delete(id);
    } catch (e) {
      print('Error deleting todo with id $id: $e');
      rethrow;
    }
  }

  /// 특정 투두의 날짜를 업데이트하는 메서드
  Future<void> updateTodoDates(Todo todo) async {
    try {
      todo.isSynced = false; // 동기화되지 않은 상태로 변경
      await todo.save();
    } catch (e) {
      print('Error updating todo dates: $e');
      rethrow;
    }
  }

  /// 투두를 추가하는 메서드
  Future<void> addTodo(Todo todo) async {
    try {
      await _todoBox.put(todo.id, todo);
    } catch (e) {
      print('Error adding todo: $e');
      rethrow;
    }
  }

  /// 특정 투두를 가져오는 메서드
  Todo? getTodoById(String id) {
    try {
      return _todoBox.get(id);
    } catch (e) {
      print('Error getting todo with id $id: $e');
      return null;
    }
  }

  /// 투두 박스를 닫는 메서드 (필요 시 사용)
  Future<void> closeBox() async {
    try {
      await _todoBox.close();
    } catch (e) {
      print('Error closing todo box: $e');
      rethrow;
    }
  }

  /// 미동기화된 투두 목록 반환
  Future<List<Todo>> getUnsyncedTodos() async {
    return _todoBox.values.where((todo) => !todo.isSynced).toList();
  }

  /// 미동기화된 투두 개수 반환
  Future<int> getUnsyncedTodosCount() async {
    return _todoBox.values.where((todo) => !todo.isSynced).length;
  }

  Future<void> fetchTodos() async {
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception('JWT 토큰이 없습니다. 다시 로그인해주세요.');
    }

    final url = Uri.parse('$baseUrl/todos/all/fetch');
    final response = await httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Todo> todos = data.map((json) => Todo.fromJson(json)).toList();

      // 기존에 저장된 투두들을 초기화하거나 병합합니다.
      // (여기서는 간단하게 클리어 후 전부 저장)
      await _todoBox.clear();
      final Map<String, Todo> todoMap = { for (var todo in todos) todo.id : todo };
      await _todoBox.putAll(todoMap);

      // 동기화 완료 시 마지막 동기화 시각을 갱신
      // (예시에서는 Hive의 별도 'sync' 박스에 저장)
      userService.updateTodoSyncTime(DateTime.now());
    }
    else{
      throw Exception('Failed to fetch todos: ${response.body}');
    }
  }

  /// 서버 동기화 예시 함수 (실제 API 호출 구현 필요)
  Future<void> commitTodo() async {
    // 미동기화된 Todo 목록 가져오기
    final unsyncedTodos = _todoBox.values.where((todo) => !todo.isSynced).toList();
    final String? token = await authService.getToken();

    // 동기화할 항목이 없다면 함수 종료
    if (unsyncedTodos.isEmpty) return;
    
    // 서버 요청 URL 설정
    final url = Uri.parse('$baseUrl/todos/all/commit');
    
    try {
      // 미동기화된 Todo들을 JSON 형식으로 변환하여 PUT 방식으로 서버에 전송
      final response = await httpClient.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(unsyncedTodos.map((todo) => todo.toJson()).toList()),
      );
      
      if (response.statusCode == 200) {
        // 동기화 성공: 각 Todo의 isSynced를 true로 업데이트 후 저장
        for (var todo in unsyncedTodos) {
          todo.isSynced = true;
          await todo.save();
        }
        userService.updateTodoSyncTime(DateTime.now());
      } else {
        throw Exception('Failed to commit todos: ${response.body}');
      }
    } catch (e) {
      print('Error commit todos: $e');
      rethrow;
    }
  } 
}