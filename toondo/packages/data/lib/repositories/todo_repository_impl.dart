import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/datasources/remote/todo_remote_datasource.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:data/constants.dart';

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
    // TODO: 백엔드와 API 스펙 논의 필요
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }

  @override
  Future<bool> commitTodos() async {
    // TODO: 백엔드와 API 스펙 논의 필요
    throw UnimplementedError('백엔드와 API 스펙 논의 필요');
  }

  @override
  Future<bool> createTodo(Todo todo) async {
    final isLocalGoal = _isLocalGoalId(todo.goalId);
    final numericGoalId = _tryParseGoalId(todo.goalId);

    // 로컬 전용 목표(TEMP-/LOCAL-/null)인 경우에만 원격 호출 스킵
    if (isLocalGoal || numericGoalId == null) {
      final localId = todo.id.startsWith('LOCAL-') ? todo.id : 'LOCAL-${DateTime.now().millisecondsSinceEpoch}';
      final localTodo = Todo(
        id: localId,
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId, // 문자열 그대로 유지해 로컬 필터링 가능
        status: todo.status,
        comment: todo.comment,
        eisenhower: todo.eisenhower,
        showOnHome: todo.showOnHome,
      );
      return await localDatasource.saveTodo(localTodo);
    }

    // 일반 목표인 경우 원격 호출 시도 (바이패스 여부와 관계없이)
    try {
      final todoId = await remoteDatasource.createTodo(
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: numericGoalId,
        eisenhower: todo.eisenhower,
        comment: todo.comment,
      );
      final updatedTodo = Todo(
        id: todoId,
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: todo.goalId,
        status: todo.status,
        comment: todo.comment,
        eisenhower: todo.eisenhower,
        showOnHome: todo.showOnHome,
      );
      return await localDatasource.saveTodo(updatedTodo);
    } catch (e) {
      // 원격 호출 실패 시 로컬 저장
      print('원격 Todo 생성 실패, 로컬 저장: $e');
      return await localDatasource.saveTodo(todo);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
  // ORIGINAL FLOW (참고용 주석)
  // try {
  //   await remoteDatasource.updateTodo(
  //     todoId: int.parse(todo.id),
  //     title: todo.title,
  //     startDate: todo.startDate,
  //     endDate: todo.endDate,
  //     goalId: todo.goalId != null ? int.parse(todo.goalId!) : null,
  //     eisenhower: todo.eisenhower.toString(),
  //   );
  //   await localDatasource.updateTodo(todo);
  // } catch (e) {
  //   await localDatasource.updateTodo(todo);
  // }
    final isLocalGoal = _isLocalGoalId(todo.goalId);
    final numericGoalId = _tryParseGoalId(todo.goalId);
    final isLocalTodo = todo.id.startsWith('LOCAL-');

    if (isLocalGoal || isLocalTodo) {
      await localDatasource.updateTodo(todo);
      return;
    }
    try {
      await remoteDatasource.updateTodo(
        todoId: int.parse(todo.id),
        title: todo.title,
        startDate: todo.startDate,
        endDate: todo.endDate,
        goalId: numericGoalId,
        eisenhower: todo.eisenhower,
        comment: todo.comment,
      );
      await localDatasource.updateTodo(todo);
    } catch (_) {
      await localDatasource.updateTodo(todo);
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
  // ORIGINAL FLOW (참고용 주석)
  // try {
  //   await remoteDatasource.deleteTodo(int.parse(todo.id));
  //   await localDatasource.deleteTodo(todo);
  // } catch (e) {
  //   await localDatasource.deleteTodo(todo);
  // }
    final isLocalTodo = todo.id.startsWith('LOCAL-');
    if (isLocalTodo) {
      await localDatasource.deleteTodo(todo);
      return;
    }
    try {
      await remoteDatasource.deleteTodo(int.parse(todo.id));
      await localDatasource.deleteTodo(todo);
    } catch (_) {
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
  // ORIGINAL FLOW (참고용 주석)
  // final updated = Todo(...)
  // try {
  //   await remoteDatasource.updateTodo(
  //     todoId: int.parse(todo.id),
  //     title: updated.title,
  //     startDate: updated.startDate,
  //     endDate: updated.endDate,
  //     goalId: updated.goalId != null ? int.parse(updated.goalId!) : null,
  //     eisenhower: updated.eisenhower.toString(),
  //   );
  //   await localDatasource.updateTodo(updated);
  // } catch (e) {
  //   await localDatasource.updateTodo(updated);
  // }
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
      showOnHome: todo.showOnHome,
    );

    final isBypass = Constants.enableLocalTestBypass;
    final isLocalGoal = _isLocalGoalId(updated.goalId);
    final isLocalTodo = todo.id.startsWith('LOCAL-');
    final numericGoalId = _tryParseGoalId(updated.goalId);
    if (isBypass || isLocalGoal || isLocalTodo) {
      await localDatasource.updateTodo(updated);
      return;
    }
    try {
      await remoteDatasource.updateTodo(
        todoId: int.parse(todo.id),
        title: updated.title,
        startDate: updated.startDate,
        endDate: updated.endDate,
        goalId: numericGoalId,
        eisenhower: updated.eisenhower,
        comment: updated.comment,
      );
      await localDatasource.updateTodo(updated);
    } catch (_) {
      await localDatasource.updateTodo(updated);
    }
  }

  @override
  Future<void> updateTodoStatus(Todo todo, double status) async {
  // ORIGINAL FLOW (참고용 주석)
  // try {
  //   final result = await remoteDatasource.toggleTodoStatus(int.parse(todo.id));
  //   final serverStatus = (result['status'] as num).toDouble();
  //   final finalUpdated = updated.copyWith(status: serverStatus); (가정)
  //   await localDatasource.updateTodo(finalUpdated);
  // } catch (e) {
  //   await localDatasource.updateTodo(updated);
  // }
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
      showOnHome: todo.showOnHome,
    );

    final isBypass = Constants.enableLocalTestBypass;
    final isLocalTodo = todo.id.startsWith('LOCAL-');
    if (isBypass || isLocalTodo) {
      await localDatasource.updateTodo(updated);
      return;
    }
    try {
      final result = await remoteDatasource.toggleTodoStatus(int.parse(todo.id));
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
        showOnHome: todo.showOnHome,
      );
      await localDatasource.updateTodo(finalUpdated);
    } catch (_) {
      await localDatasource.updateTodo(updated);
    }
  }

  // --- Helpers ---
  bool _isLocalGoalId(String? goalId) {
    if (goalId == null) return true; // null은 로컬 미지정으로 취급
    return goalId.startsWith('TEMP-') || goalId == '-1';
  }

  int? _tryParseGoalId(String? goalId) {
    if (goalId == null) return null;
    return int.tryParse(goalId); // 실패 시 null
  }
}
