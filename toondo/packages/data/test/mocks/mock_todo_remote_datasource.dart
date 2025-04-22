import 'package:mockito/mockito.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:domain/entities/todo.dart';

class MockTodoRemoteDatasource extends Mock implements TodoRemoteDataSource {
  @override
  Future<List<Todo>> fetchTodos() => Future.value([]);

  @override
  Future<bool> commitTodos(List<Todo> unsyncedTodos, List<Todo> deletedTodos) => Future.value(false);
}