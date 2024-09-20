// providers/todo_provider.dart

import 'package:flutter/foundation.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';

// providers/todo_provider.dart

class TodoProvider with ChangeNotifier {
  Map<String, List<Todo>> _todosByDate = {};

  List<Todo> getTodosForDate(DateTime date) {
    String dateKey = date.toIso8601String().substring(0, 10);
    return _todosByDate[dateKey] ?? [];
  }

  Future<void> loadTodosForDate(DateTime date) async {
    List<Todo> todos = await TodoService.loadTodosForDate(date);
    String dateKey = date.toIso8601String().substring(0, 10);
    _todosByDate[dateKey] = todos;
    notifyListeners();
  }

  Future<void> addTodoForDate(DateTime date, Todo todo) async {
    String dateKey = date.toIso8601String().substring(0, 10);
    _todosByDate.putIfAbsent(dateKey, () => []);
    _todosByDate[dateKey]!.add(todo);
    await TodoService.saveTodosForDate(date, _todosByDate[dateKey]!);
    notifyListeners();
  }

  Future<void> updateTodoForDate(DateTime date, Todo updatedTodo) async {
    String dateKey = date.toIso8601String().substring(0, 10);
    List<Todo>? todos = _todosByDate[dateKey];
    if (todos != null) {
      int index = todos.indexWhere((todo) => todo.title == updatedTodo.title);
      if (index != -1) {
        todos[index] = updatedTodo;
        await TodoService.saveTodosForDate(date, todos);
        notifyListeners();
      }
    }
  }

  Future<void> deleteTodoForDate(DateTime date, Todo todo) async {
    String dateKey = date.toIso8601String().substring(0, 10);
    List<Todo>? todos = _todosByDate[dateKey];
    if (todos != null) {
      todos.removeWhere((t) => t.title == todo.title);
      await TodoService.saveTodosForDate(date, todos);
      notifyListeners();
    }
  }
}