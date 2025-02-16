import 'package:hive/hive.dart';
import 'package:data/models/todo_model.dart';
import 'package:domain/entities/todo.dart';

class TodoLocalDatasource {
  Box<TodoModel> todoBox = Hive.box<TodoModel>('todos');
  Box<TodoModel> deletedTodoBox = Hive.box<TodoModel>('deleted_todos');

  Future<void> clearTodos() async {
    await todoBox.clear();
  }

  Future<bool> saveTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo);
      await todoBox.put(todo.id, model);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getAllTodos() {
    return todoBox.values.map((model) => model.toEntity()).toList();
  }

  List<Todo> getUnsyncedTodos() {
    return todoBox.values
        .where((model) => !model.synced)
        .map((model) => model.toEntity())
        .toList();
  }

  Future<void> updateTodo(Todo todo) async {
    final model = TodoModel.fromEntity(todo);
    model.synced = false;
    await todoBox.put(todo.id, model);
  }

  Future<void> deleteTodo(Todo todo) async {
    await todoBox.delete(todo.id);
    final model = TodoModel.fromEntity(todo);
    await deletedTodoBox.put(todo.id, model);
  }

  List<Todo> getDeletedTodos() {
    return deletedTodoBox.values.map((model) => model.toEntity()).toList();
  }

  Future<void> clearDeletedTodos() async {
    await deletedTodoBox.clear();
  }

  Future<void> syncTodos(List<Todo> committedTodos) async {
    for (var todo in committedTodos) {
      final updatedModel = TodoModel.fromEntity(todo);
      updatedModel.synced = true;
      await todoBox.put(updatedModel.id, updatedModel);
    }
  }
}
