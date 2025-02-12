import 'package:hive/hive.dart';
import 'package:todo_with_alarm/data/models/todo.dart';

class TodoLocalDatasource {
  // Todo 저장용 Hive 박스
  Box<Todo> todoBox = Hive.box<Todo>('todos');
  // 로컬에서 삭제된 Todo 저장용 Hive 박스 (휴지통 역할)
  Box<Todo> deletedTodoBox = Hive.box<Todo>('deleted_todos');

  Future<void> clearTodos() async {
    await todoBox.clear();
  }

  Future<bool> saveTodo(Todo todo) async {
    try {
      await todoBox.put(todo.id, todo);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getAllTodos() {
    return todoBox.values.toList();
  }

  List<Todo> getUnsyncedTodos() {
    return todoBox.values.where((t) => !t.isSynced).toList();
  }

  Future<void> updateTodo(Todo todo) async {
    await saveTodo(todo);
  }

  Future<void> deleteTodo(Todo todo) async {
    await todoBox.delete(todo.id);
    await deletedTodoBox.put(todo.id, todo);
  }

  List<Todo> getDeletedTodos() {
    return deletedTodoBox.values.toList();
  }

  Future<void> clearDeletedTodos() async {
    await deletedTodoBox.clear();
  }

  Future<void> syncTodos(List<Todo> committedTodos) async {
    for (var todo in committedTodos) {
      todo.isSynced = true;
      await saveTodo(todo);
    }
  }
}
