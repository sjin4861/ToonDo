// lib/services/todo_service.dart

import 'package:hive/hive.dart';
import 'package:todo_with_alarm/models/todo.dart';

class TodoService {
  final Box<Todo> _todoBox;

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

  /// 특정 투두의 상태를 업데이트하는 메서드
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
}