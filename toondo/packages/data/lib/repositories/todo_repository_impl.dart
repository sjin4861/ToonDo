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
    // TODO: 백엔드와 얘기 필요 - API 스펙 확정 후 구현
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }

  @override
  Future<bool> commitTodos() async {
    // TODO: 백엔드와 얘기 필요 - API 스펙 확정 후 구현
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }

  @override
  Future<bool> createTodo(Todo todo) async {
    try {
      // 1. 원격 서버에 투두 생성
      final todoId = await remoteDatasource.createTodo(
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId != null ? int.parse(todo.goalId!) : null,
        eisenhower: todo.eisenhower.toString(),
      );

      // 2. 서버에서 반환된 ID로 Todo 업데이트
      final updatedTodo = Todo(
        id: todoId,
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId,
        status: todo.status,
        comment: todo.comment,
        eisenhower: todo.eisenhower,
      );

      // 3. 로컬에 저장
      final isCreated = await localDatasource.saveTodo(updatedTodo);
      return isCreated;
    } catch (e) {
      // 원격 생성 실패시 로컬에만 저장 (나중에 동기화)
      return await localDatasource.saveTodo(todo);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      // 1. 원격 서버에서 투두 업데이트
      await remoteDatasource.updateTodo(
        todoId: int.parse(todo.id),
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId != null ? int.parse(todo.goalId!) : null,
        eisenhower: todo.eisenhower.toString(),
      );

      // 2. 로컬에 업데이트
      await localDatasource.updateTodo(todo);
    } catch (e) {
      // 원격 업데이트 실패시 로컬에만 업데이트 (나중에 동기화)
      await localDatasource.updateTodo(todo);
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    try {
      // 1. 원격 서버에서 투두 삭제
      await remoteDatasource.deleteTodo(int.parse(todo.id));

      // 2. 로컬에서 삭제
      await localDatasource.deleteTodo(todo);
    } catch (e) {
      // 원격 삭제 실패시 로컬에서만 삭제 (나중에 동기화)
      await localDatasource.deleteTodo(todo);
    }
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
    // 날짜 업데이트 후 Todo 객체 생성
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: newStartDate,
      endDate: newEndDate,
      goalId: todo.goalId,
      status: todo.status,
      comment: todo.comment,
      eisenhower: todo.eisenhower,
    );

    try {
      // 1. 원격 서버에서 투두 업데이트
      await remoteDatasource.updateTodo(
        todoId: int.parse(todo.id),
        title: updated.title,
        startDate: updated.startDate,
        endDate: updated.endDate,
        goalId: updated.goalId != null ? int.parse(updated.goalId!) : null,
        eisenhower: updated.eisenhower.toString(),
      );

      // 2. 로컬에 업데이트
      await localDatasource.updateTodo(updated);
    } catch (e) {
      // 원격 업데이트 실패시 로컬에만 업데이트 (나중에 동기화)
      await localDatasource.updateTodo(updated);
    }
  }

  @override
  Future<void> updateTodoStatus(Todo todo, double status) async {
    // 상태는 0.0(진행) 또는 1.0(완료)만 허용
    final normalizedStatus = status == 1.0 ? 1.0 : 0.0;

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
    );

    try {
      // 1. 원격 서버에서 투두 상태 토글 (항상 toggleTodoStatus API 사용)
      final result = await remoteDatasource.toggleTodoStatus(
        int.parse(todo.id),
      );

      // 2. 서버 응답에서 실제 상태값 가져와서 로컬 업데이트
      final serverStatus = (result['status'] as num).toDouble();
      final finalUpdated = Todo(
        id: todo.id,
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId,
        status: serverStatus,
        comment: todo.comment,
        eisenhower: todo.eisenhower,
      );

      await localDatasource.updateTodo(finalUpdated);
    } catch (e) {
      // 원격 업데이트 실패시 로컬에만 업데이트 (나중에 동기화)
      await localDatasource.updateTodo(updated);
    }
  }
}
