import 'package:hive/hive.dart';
import 'package:data/models/todo_model.dart';
import 'package:domain/entities/todo.dart';

class TodoLocalDatasource {
  // Hive 박스 타입을 TodoModel로 변경
  Box<TodoModel> todoBox = Hive.box<TodoModel>('todos');
  Box<TodoModel> deletedTodoBox = Hive.box<TodoModel>('deleted_todos');

  Future<void> clearTodos() async {
    await todoBox.clear();
  }

  Future<bool> saveTodo(Todo todo) async {
    try {
      // 도메인 Todo를 Hive 저장용 Model로 변환
      final model = TodoModel.fromEntity(todo);
      await todoBox.put(todo.id, model);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getAllTodos() {
    // 저장된 모델을 도메인 Entity로 변환 후 반환
    return todoBox.values.map((model) => model.toEntity()).toList();
  }

  List<Todo> getUnsyncedTodos() {
    return todoBox.values
        .where((model) => !model.isSynced)
        .map((model) => model.toEntity())
        .toList();
  }

  Future<void> updateTodo(Todo todo) async {
    await saveTodo(todo);
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
    // 각 Todo의 동기화 상태를 true로 갱신 후 저장
    for (var todo in committedTodos) {
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        goalId: todo.goalId,
        status: todo.status,
        comment: todo.comment,
        startDate: todo.startDate,
        endDate: todo.endDate,
        urgency: todo.urgency,
        importance: todo.importance,
      );
      // todo.isSynced = true; // Entity는 보통 immutable하므로, 새로 생성하거나 업데이트 처리
      await saveTodo(updatedTodo);
    }
  }
}
