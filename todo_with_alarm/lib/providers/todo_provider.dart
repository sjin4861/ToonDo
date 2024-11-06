// providers/todo_provider.dart

import 'package:flutter/foundation.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  // 모든 투두 리스트를 가져오는 메서드
  List<Todo> getAllTodos() {
    return _todos;
  }

  // 특정 날짜에 해당하는 투두 리스트를 가져오는 메서드
  List<Todo> getTodosForDate(DateTime date) {
    return _todos.where((todo) {
      return (todo.startDate.isBefore(date) || todo.startDate.isAtSameMomentAs(date)) &&
          (todo.endDate.isAfter(date) || todo.endDate.isAtSameMomentAs(date));
    }).toList();
  }

  // 모든 투두를 로드하는 메서드
  Future<void> loadTodos() async {
    _todos = await TodoService.loadAllTodos();
    notifyListeners();
  }

  // 투두를 추가하는 메서드
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await TodoService.saveAllTodos(_todos);
    notifyListeners();
  }

  // 투두를 업데이트하는 메서드
  Future<void> updateTodo(Todo updatedTodo) async {
    int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      await TodoService.saveAllTodos(_todos);
      notifyListeners();
    }
  }

  // 투두를 삭제하는 메서드
  Future<void> deleteTodo(Todo todo) async {
    _todos.removeWhere((t) => t.id == todo.id);
    await TodoService.saveAllTodos(_todos);
    notifyListeners();
  }
  // 투두 ID로 삭제하는 메서드 추가
  Future<void> deleteTodoById(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await TodoService.saveAllTodos(_todos);
    notifyListeners();
  }
}