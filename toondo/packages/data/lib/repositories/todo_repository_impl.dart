import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDatasource;
  final TodoLocalDatasource localDatasource;

  TodoRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Todo>> fetchTodos() async {
    final todos = await remoteDatasource.fetchTodos();
    await localDatasource.clearTodos();
    for (var todo in todos) {
      await localDatasource.saveTodo(todo);
    }
    return todos;
  }

  @override
  Future<bool> commitTodos() async {
    final unsyncedTodos = localDatasource.getUnsyncedTodos();
    final deletedTodos = localDatasource.getDeletedTodos();
    final isCommitted = await remoteDatasource.commitTodos(
      unsyncedTodos,
      deletedTodos,
    );
    if (!isCommitted) {
      throw Exception('Failed to commit todos');
    }
    localDatasource.syncTodos(unsyncedTodos);
    localDatasource.clearDeletedTodos();
    return isCommitted;
  }

  @override
  Future<bool> createTodo(Todo todo) async {
    final isCreated = await localDatasource.saveTodo(todo);
    return isCreated;
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await localDatasource.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await localDatasource.deleteTodo(todo);
  }

  @override
  List<Todo> getLocalTodos() {
    return localDatasource.getAllTodos();
  }

  @override
  Future<void> updateTodoDates(
    Todo todo,
    DateTime newStartDate,
    DateTime newEndDate,
  ) async {
    // 날짜 업데이트 후 로컬 DB에 저장
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: newStartDate,
      endDate: newEndDate,
      goalId: todo.goalId,
      status: todo.status,
      comment: todo.comment,
      urgency: todo.urgency,
      importance: todo.importance,
    );
    await localDatasource.updateTodo(updated);
  }

  @override
  Future<void> updateTodoStatus(Todo todo, double status) async {
    // 상태 업데이트 후 로컬 DB에 저장
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: todo.startDate,
      endDate: todo.endDate,
      goalId: todo.goalId,
      status: status,
      comment: todo.comment,
      urgency: todo.urgency,
      importance: todo.importance,
    );
    await localDatasource.updateTodo(updated);
  }
}
