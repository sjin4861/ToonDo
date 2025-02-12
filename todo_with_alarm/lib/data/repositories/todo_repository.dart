import 'package:todo_with_alarm/data/datasources/local/todo_local_datasource.dart';
import 'package:todo_with_alarm/data/datasources/remote/todo_remote_datasource.dart';
import 'package:todo_with_alarm/data/models/todo.dart';

class TodoRepository {
  final TodoLocalDatasource localDatasource;
  final TodoRemoteDataSource remoteDatasource;

  TodoRepository({required this.localDatasource, required this.remoteDatasource});

  Future<List<Todo>> fetchTodos() async {
    final todos = await remoteDatasource.fetchTodos();
    await localDatasource.clearTodos();
    for (var todo in todos) {
      await localDatasource.saveTodo(todo);
    }
    return todos;
  }

  Future<bool> commitTodos() async {
    final unsyncedTodos = localDatasource.getUnsyncedTodos();
    final deletedTodos = localDatasource.getDeletedTodos();
    final isCommitted = await remoteDatasource.commitTodos(unsyncedTodos, deletedTodos);
    if (!isCommitted) {
      throw Exception('Failed to commit todos');
    }
    localDatasource.syncTodos(unsyncedTodos);
    localDatasource.clearDeletedTodos();
    return isCommitted;
  }

  Future<bool> createTodo(Todo todo) async {
    final isCreated = localDatasource.saveTodo(todo);
    return isCreated;
  }

  Future<void> updateTodo(Todo todo) async {
    await localDatasource.updateTodo(todo);
  }

  Future<void> deleteTodo(Todo todo) async {
    await localDatasource.deleteTodo(todo);
  }

  List<Todo> getLocalTodos() {
    return localDatasource.getAllTodos();
  }
}
