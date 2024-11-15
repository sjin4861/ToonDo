// viewmodels/todo_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

class TodoViewModel extends ChangeNotifier {
  List<Todo> _todos = [];

  final TodoService _todoService;

  TodoViewModel(this._todoService);

  // 모든 투두 리스트를 가져오는 메서드
  List<Todo> get allTodos => _todos;

  // 투두 리스트 설정 메서드
  void setTodos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  // 특정 날짜에 해당하는 투두 리스트를 가져오는 메서드
  List<Todo> getTodosForDate(DateTime date) {
    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    return _todos.where((todo) {
      DateTime startDateOnly = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime endDateOnly = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      return (startDateOnly.isBefore(dateOnly) || startDateOnly.isAtSameMomentAs(dateOnly)) &&
          (endDateOnly.isAfter(dateOnly) || endDateOnly.isAtSameMomentAs(dateOnly));
    }).toList();
  }

  // 모든 투두를 로드하는 메서드
  Future<void> loadTodos() async {
    _todos = await _todoService.loadTodoList();
    notifyListeners();
  }

  // 투두 저장 메서드
  Future<void> saveTodos() async {
    await _todoService.saveTodoList(_todos);
  }

  // 투두를 추가하는 메서드
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await saveTodos();
    notifyListeners();
  }

  // 투두를 업데이트하는 메서드
  Future<void> updateTodo(Todo updatedTodo) async {
    int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      await saveTodos();
      notifyListeners();
    }
  }

  // 투두 상태 업데이트 메서드
  Future<void> updateTodoStatus(String todoId, double status) async {
    int index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index != -1) {
      _todos[index].status = status;
      await saveTodos();
      notifyListeners();
    }
  }

  // 투두를 삭제하는 메서드
  Future<void> deleteTodoById(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await saveTodos();
    notifyListeners();
  }

  // 기타 필요한 메서드 추가...
}