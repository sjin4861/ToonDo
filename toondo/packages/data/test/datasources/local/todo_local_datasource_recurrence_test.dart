import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:data/datasources/local/todo_local_datasource.dart';
import 'package:data/models/recurrence_rule_model.dart';
import 'package:data/models/todo_model.dart';
import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';

void main() {
  late Directory tempDir;
  late Box<TodoModel> todoBox;
  late Box<TodoModel> deletedBox;
  late TodoLocalDatasource ds;
  var counter = 0;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('ds_test_');
    Hive.init(tempDir.path);
    Hive.registerAdapter(TodoModelAdapter());
    Hive.registerAdapter(RecurrenceFrequencyModelAdapter());
    Hive.registerAdapter(RecurrenceEndKindAdapter());
    Hive.registerAdapter(RecurrenceEndModelAdapter());
    Hive.registerAdapter(RecurrenceRuleModelAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    counter++;
    todoBox = await Hive.openBox<TodoModel>('todos_$counter');
    deletedBox = await Hive.openBox<TodoModel>('deleted_$counter');
    ds = TodoLocalDatasource(todoBox, deletedBox);
  });

  tearDown(() async {
    await todoBox.close();
    await deletedBox.close();
  });

  Todo seriesTodo({String id = 's1'}) => Todo(
        id: id,
        title: 'series',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 1),
        recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily),
      );

  Todo occurrenceOf(String seriesId, DateTime date,
          {double status = 0.0, String? id}) =>
      Todo(
        id: id ?? '$seriesId@${date.toIso8601String()}',
        title: 'occurrence',
        startDate: date,
        endDate: date,
        status: status,
        seriesId: seriesId,
        occurrenceDate: date,
      );

  test('getRecurringSeries는 시리즈만 반환 (단일 todo / occurrence 제외)', () async {
    await ds.saveTodo(Todo(
      id: 'plain',
      title: 'normal',
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 1),
    ));
    await ds.saveTodo(seriesTodo(id: 's1'));
    await ds.saveTodo(occurrenceOf('s1', DateTime(2025, 1, 2)));

    final series = ds.getRecurringSeries();
    expect(series, hasLength(1));
    expect(series.first.id, 's1');
  });

  test('findOccurrence는 (seriesId, occurrenceDate)로 정확 매칭', () async {
    await ds.saveTodo(occurrenceOf('s1', DateTime(2025, 1, 5), status: 1.0));
    await ds.saveTodo(occurrenceOf('s1', DateTime(2025, 1, 6)));

    final hit = ds.findOccurrence(
      seriesId: 's1',
      occurrenceDate: DateTime(2025, 1, 5),
    );
    expect(hit, isNotNull);
    expect(hit!.status, 1.0);

    expect(
      ds.findOccurrence(
        seriesId: 's1',
        occurrenceDate: DateTime(2025, 1, 7),
      ),
      isNull,
    );
  });

  test('deleteSeries는 시리즈와 미완료 occurrence는 삭제, 완료는 보존', () async {
    await ds.saveTodo(seriesTodo(id: 's1'));
    await ds.saveTodo(occurrenceOf('s1', DateTime(2025, 1, 2), status: 1.0, id: 'done'));
    await ds.saveTodo(occurrenceOf('s1', DateTime(2025, 1, 3), id: 'pending'));
    await ds.saveTodo(seriesTodo(id: 's2'));

    await ds.deleteSeriesAndUnfinishedOccurrences('s1');

    final remaining = ds.getAllTodos().map((t) => t.id).toSet();
    expect(remaining, contains('done'));
    expect(remaining, contains('s2'));
    expect(remaining, isNot(contains('s1')));
    expect(remaining, isNot(contains('pending')));
  });
}
