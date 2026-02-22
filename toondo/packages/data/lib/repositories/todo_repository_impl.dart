import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:data/constants.dart';
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
    if (!Constants.remoteApiEnabled) {
      return localDatasource.getAllTodos();
    }

    try {
      final remoteTodos = await remoteDatasource.fetchTodos();
      await localDatasource.clearTodos();
      for (final todo in remoteTodos) {
        await localDatasource.saveTodo(todo);
      }
      return remoteTodos;
    } catch (_) {
      return localDatasource.getAllTodos();
    }
  }

  @override
  Future<bool> commitTodos() async {
    if (!Constants.remoteApiEnabled) {
      return true;
    }

    try {
      final unsynced = localDatasource.getUnsyncedTodos();
      final deleted = localDatasource.getDeletedTodos();
      final committed = await remoteDatasource.commitTodos(unsynced, deleted);
      await localDatasource.syncTodos(committed ? unsynced : []);
      if (committed) {
        await localDatasource.clearDeletedTodos();
      }
      return committed;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> createTodo(Todo todo) async {
    if (Constants.remoteApiEnabled) {
      try {
        final createdId = await remoteDatasource.createTodo(
          title: todo.title,
          startDate: todo.startDate,
          endDate: todo.endDate,
          goalId: _tryParseGoalId(todo.goalId),
          eisenhower: todo.eisenhower,
          comment: todo.comment,
        );
        final createdTodo = Todo(
          id: createdId,
          title: todo.title,
          startDate: todo.startDate,
          endDate: todo.endDate,
          goalId: todo.goalId,
          status: todo.status,
          comment: todo.comment,
          eisenhower: todo.eisenhower,
          showOnHome: todo.showOnHome,
        );
        return localDatasource.saveTodo(createdTodo);
      } catch (_) {
        return localDatasource.saveTodo(todo);
      }
    }

    final localId =
        todo.id.startsWith('LOCAL-') ? todo.id : 'LOCAL-${todo.id}';
    final localTodo = Todo(
      id: localId,
      title: todo.title,
      startDate: todo.startDate,
      endDate: todo.endDate,
      goalId: todo.goalId,
      status: todo.status,
      comment: todo.comment,
      eisenhower: todo.eisenhower,
      showOnHome: todo.showOnHome,
    );
    return localDatasource.saveTodo(localTodo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    if (Constants.remoteApiEnabled) {
      try {
        final todoId = int.tryParse(todo.id);
        if (todoId != null) {
          await remoteDatasource.updateTodo(
            todoId: todoId,
            title: todo.title,
            startDate: todo.startDate,
            endDate: todo.endDate,
            goalId: _tryParseGoalId(todo.goalId),
            eisenhower: todo.eisenhower,
            comment: todo.comment,
          );
        }
      } catch (_) {}
    }

    await localDatasource.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    if (Constants.remoteApiEnabled) {
      try {
        final todoId = int.tryParse(todo.id);
        if (todoId != null) {
          await remoteDatasource.deleteTodo(todoId);
        }
      } catch (_) {}
    }

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
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: newStartDate,
      endDate: newEndDate,
      goalId: todo.goalId,
      status: todo.status,
      comment: todo.comment,
      eisenhower: todo.eisenhower,
      showOnHome: todo.showOnHome,
    );

    if (Constants.remoteApiEnabled) {
      try {
        final todoId = int.tryParse(todo.id);
        if (todoId != null) {
          await remoteDatasource.updateTodo(
            todoId: todoId,
            title: todo.title,
            startDate: newStartDate,
            endDate: newEndDate,
            goalId: _tryParseGoalId(todo.goalId),
            eisenhower: todo.eisenhower,
            comment: todo.comment,
          );
        }
      } catch (_) {}
    }

    await localDatasource.updateTodo(updated);
  }

  @override
  Future<void> updateTodoStatus(Todo todo, double status) async {
    if (Constants.remoteApiEnabled) {
      try {
        final todoId = int.tryParse(todo.id);
        if (todoId != null) {
          final server = await remoteDatasource.toggleTodoStatus(todoId);
          final remoteStatus = (server['status'] as num).toDouble();
          final remoteUpdated = Todo(
            id: todo.id,
            title: todo.title,
            startDate: todo.startDate,
            endDate: todo.endDate,
            goalId: todo.goalId,
            status: remoteStatus,
            comment: todo.comment,
            eisenhower: todo.eisenhower,
            showOnHome: todo.showOnHome,
          );
          await localDatasource.updateTodo(remoteUpdated);
          return;
        }
      } catch (_) {}
    }

    final normalizedStatus = status >= 100 ? 100.0 : 0.0;

    // 상태 업데이트 후 Todo 객체 생성
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: todo.startDate,
      endDate: todo.endDate,
      goalId: todo.goalId,
      status: normalizedStatus,
      comment: todo.comment,
      eisenhower: todo.eisenhower,
      showOnHome: todo.showOnHome,
    );
    await localDatasource.updateTodo(updated);
  }

  int? _tryParseGoalId(String? goalId) {
    if (goalId == null) return null;
    return int.tryParse(goalId);
  }
}
