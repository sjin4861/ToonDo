import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:data/models/recurrence_rule_model.dart';
import 'package:data/models/todo_model.dart';
import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/usecases/todo/create_recurring_todo.dart';
import 'package:domain/usecases/todo/delete_recurring_todo.dart';
import 'package:domain/usecases/todo/expand_recurring_todos_for_date.dart';

// In-process repository that hooks the real local datasource without
// pulling in the remote/Dio stack. Mirrors the four methods exercised by
// the recurring flow; everything else is unimplemented because the test
// does not call them.
class _LocalOnlyTodoRepository implements TodoRepository {
  _LocalOnlyTodoRepository(this.local);
  final TodoLocalDatasource local;

  @override
  Future<bool> createTodo(Todo todo) => local.saveTodo(todo);

  @override
  Future<List<Todo>> getRecurringSeries() async => local.getRecurringSeries();

  @override
  Future<Todo?> findOccurrence({
    required String seriesId,
    required DateTime occurrenceDate,
  }) async =>
      local.findOccurrence(
        seriesId: seriesId,
        occurrenceDate: occurrenceDate,
      );

  @override
  Future<void> deleteSeries(String seriesId) =>
      local.deleteSeriesAndUnfinishedOccurrences(seriesId);

  @override
  Future<Todo> materializeOccurrence(Todo occurrence) async {
    await local.saveTodo(occurrence);
    return occurrence;
  }

  @override
  Future<void> updateTodoStatus(Todo todo, double status) async {
    final updated = Todo(
      id: todo.id,
      title: todo.title,
      startDate: todo.startDate,
      endDate: todo.endDate,
      goalId: todo.goalId,
      status: status,
      comment: todo.comment,
      eisenhower: todo.eisenhower,
      showOnHome: todo.showOnHome,
      recurrence: todo.recurrence,
      seriesId: todo.seriesId,
      occurrenceDate: todo.occurrenceDate,
    );
    await local.updateTodo(updated);
  }

  // Unused by this test.
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory tempDir;
  late Box<TodoModel> todoBox;
  late Box<TodoModel> deletedBox;
  late TodoLocalDatasource ds;
  late _LocalOnlyTodoRepository repo;
  late CreateRecurringTodoUseCase create;
  late ExpandRecurringTodosForDateUseCase expand;
  late DeleteRecurringTodoUseCase deleteSeries;
  var counter = 0;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('recurring_flow_');
    Hive.init(tempDir.path);
    Hive.registerAdapter(TodoModelAdapter());
    Hive.registerAdapter(RecurrenceFrequencyModelAdapter());
    Hive.registerAdapter(RecurrenceEndKindAdapter());
    Hive.registerAdapter(RecurrenceEndModelAdapter());
    Hive.registerAdapter(RecurrenceRuleModelAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  setUp(() async {
    counter++;
    todoBox = await Hive.openBox<TodoModel>('flow_todos_$counter');
    deletedBox = await Hive.openBox<TodoModel>('flow_deleted_$counter');
    ds = TodoLocalDatasource(todoBox, deletedBox);
    repo = _LocalOnlyTodoRepository(ds);
    create = CreateRecurringTodoUseCase(repo);
    expand = ExpandRecurringTodosForDateUseCase(repo);
    deleteSeries = DeleteRecurringTodoUseCase(repo);
  });

  tearDown(() async {
    await todoBox.close();
    await deletedBox.close();
  });

  test('주 3회(월/수/금) 시리즈 생성 → expand → 한 회차 완료 → 삭제 후 완료 이력 보존', () async {
    // 1. 주 3회 시리즈 생성 (시작: 월요일 2025-01-06)
    final monday = DateTime(2025, 1, 6);
    final series = Todo(
      id: 'series-exercise',
      title: '운동',
      startDate: monday,
      endDate: monday,
      showOnHome: true,
      recurrence: RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        byWeekdays: const [1, 3, 5],
      ),
    );
    final created = await create(series);
    expect(created, isTrue);

    // 2. 월/화/수 expand 결과 검증
    final mon = await expand(DateTime(2025, 1, 6));
    final tue = await expand(DateTime(2025, 1, 7));
    final wed = await expand(DateTime(2025, 1, 8));
    expect(mon, hasLength(1));
    expect(tue, isEmpty);
    expect(wed, hasLength(1));

    // 3. 월요일 회차를 완료 (가상 인스턴스 → 머터리얼라이즈)
    final monOccurrence = mon.single;
    expect(monOccurrence.seriesId, 'series-exercise');
    await repo.updateTodoStatus(monOccurrence, 1.0);

    // 4. 같은 날 다시 expand → 머터리얼라이즈된 완료 인스턴스가 반환되어야
    final monAgain = await expand(DateTime(2025, 1, 6));
    expect(monAgain.single.status, 1.0);
    expect(monAgain.single.seriesId, 'series-exercise');

    // 5. 시리즈 삭제 → 시리즈 + 미완료 occurrence 제거, 완료 이력 보존
    await deleteSeries('series-exercise');

    // 시리즈가 사라졌으므로 미래 expand 결과는 빈 리스트
    expect(await expand(DateTime(2025, 1, 8)), isEmpty);
    expect(await expand(DateTime(2025, 1, 10)), isEmpty);

    // 완료된 월요일 인스턴스는 box에 남아있다 (직접 확인)
    final all = ds.getAllTodos();
    expect(all.any((t) => t.seriesId == 'series-exercise' && t.isFinished()),
        isTrue);
    expect(all.any((t) => t.id == 'series-exercise'), isFalse);
  });
}
