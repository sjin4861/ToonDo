import 'package:hive/hive.dart';
import 'package:data/models/todo_model.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TodoLocalDatasource {
  Box<TodoModel> todoBox;
  Box<TodoModel> deletedTodoBox;

  TodoLocalDatasource(
    @Named('todoBox') this.todoBox,
    @Named('deletedTodoBox') this.deletedTodoBox,
  );

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

  List<Todo> getRecurringSeries() {
    return todoBox.values
        .where((m) => m.recurrence != null && m.seriesId == null)
        .map((m) => m.toEntity())
        .toList();
  }

  Todo? findOccurrence({
    required String seriesId,
    required DateTime occurrenceDate,
  }) {
    final dayOnly = DateTime(
      occurrenceDate.year,
      occurrenceDate.month,
      occurrenceDate.day,
    );
    for (final m in todoBox.values) {
      if (m.seriesId != seriesId) continue;
      final occ = m.occurrenceDate;
      if (occ == null) continue;
      if (DateTime(occ.year, occ.month, occ.day) == dayOnly) {
        return m.toEntity();
      }
    }
    return null;
  }

  Future<void> deleteSeriesAndUnfinishedOccurrences(String seriesId) async {
    await todoBox.delete(seriesId);
    final unfinishedKeys = todoBox.values
        .where((m) =>
            m.seriesId == seriesId && (m.status < 1.0))
        .map((m) => m.id)
        .toList();
    for (final id in unfinishedKeys) {
      await todoBox.delete(id);
    }
  }
}
