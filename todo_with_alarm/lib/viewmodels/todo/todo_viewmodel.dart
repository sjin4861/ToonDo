import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

class TodoViewModel extends ChangeNotifier {
  List<Todo> _todos = [];

  final TodoService _todoService;

  TodoViewModel(this._todoService);

  // 모든 투두 리스트를 가져오는 메서드
  List<Todo> get allTodos => _todos;

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

  // 투두를 추가하는 메서드
  Future<void> addTodo(Todo todo) async {
    try {
      await _todoService.addTodo(todo);
      _todos.add(todo);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }
  
  // 투두를 업데이트하는 메서드
  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      await _todoService.updateTodoStatus(updatedTodo.id, updatedTodo.status);
      int index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating todo: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }

  // 투두 상태 업데이트 메서드
  Future<void> updateTodoStatus(String todoId, double status) async {
    await _todoService.updateTodoStatus(todoId, status);
    await loadTodos();
  }

  // 투두를 삭제하는 메서드
  Future<void> deleteTodoById(String id) async {
    try {
      await _todoService.deleteTodoById(id);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo with id $id: $e');
      // 추가적인 에러 처리 로직을 여기에 작성할 수 있습니다.
    }
  }

  // 투두 날짜 업데이트 메서드
  Future<void> updateTodoDates(Todo todo, DateTime newStartDate, DateTime newEndDate) async {
    todo.startDate = newStartDate;
    todo.endDate = newEndDate;
    await _todoService.updateTodoDates(todo);
    await loadTodos();
  }
}