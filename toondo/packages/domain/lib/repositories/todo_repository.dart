import 'package:domain/entities/todo.dart';

abstract class TodoRepository {
  List<Todo> getLocalTodos();
  Future<void> deleteTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<bool> createTodo(Todo todo);
  Future<bool> commitTodos();
  Future<List<Todo>> fetchTodos();
  Future<void> updateTodoDates(
    Todo todo,
    DateTime newStartDate,
    DateTime newEndDate,
  );
  Future<void> updateTodoStatus(Todo todo, double status);

  Future<List<Todo>> getRecurringSeries();

  Future<void> deleteSeries(String seriesId);

  Future<Todo?> findOccurrence({
    required String seriesId,
    required DateTime occurrenceDate,
  });

  Future<Todo> materializeOccurrence(Todo occurrence);
}
