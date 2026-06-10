import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:data/models/todo_model.dart';
import 'package:data/models/recurrence_rule_model.dart';
import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('todo_model_test_');
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

  group('TodoModel Hive round-trip', () {
    test('반복 없는 Todo는 nullable 필드가 모두 null로 보존', () async {
      final box = await Hive.openBox<TodoModel>('non_recurring_${DateTime.now().microsecondsSinceEpoch}');
      final model = TodoModel(
        id: 't1',
        title: '일반 할 일',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 1),
      );
      await box.put(model.id, model);

      final restored = box.get('t1')!;
      expect(restored.recurrence, isNull);
      expect(restored.seriesId, isNull);
      expect(restored.occurrenceDate, isNull);
      expect(restored.toEntity().isRecurring, isFalse);

      await box.close();
    });

    test('반복 규칙이 포함된 Todo는 라운드트립 후 동일', () async {
      final box = await Hive.openBox<TodoModel>('recurring_${DateTime.now().microsecondsSinceEpoch}');
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        byWeekdays: const [1, 3, 5],
        end: const EndAfterCount(10),
      );
      final entity = Todo(
        id: 's1',
        title: '주 3회 운동',
        startDate: DateTime(2025, 1, 6),
        endDate: DateTime(2025, 1, 6),
        recurrence: rule,
      );
      await box.put(entity.id, TodoModel.fromEntity(entity));

      final restored = box.get('s1')!.toEntity();
      expect(restored.recurrence, equals(rule));
      expect(restored.isRecurring, isTrue);
      expect(restored.isRecurringSeries, isTrue);

      await box.close();
    });

    test('머터리얼라이즈된 occurrence는 seriesId/occurrenceDate 보존', () async {
      final box = await Hive.openBox<TodoModel>('materialized_${DateTime.now().microsecondsSinceEpoch}');
      final occurrence = Todo(
        id: 'm1',
        title: '운동',
        startDate: DateTime(2025, 1, 8),
        endDate: DateTime(2025, 1, 8),
        status: 1.0,
        seriesId: 's1',
        occurrenceDate: DateTime(2025, 1, 8),
      );
      await box.put(occurrence.id, TodoModel.fromEntity(occurrence));

      final restored = box.get('m1')!.toEntity();
      expect(restored.seriesId, 's1');
      expect(restored.occurrenceDate, DateTime(2025, 1, 8));
      expect(restored.status, 1.0);
      expect(restored.isRecurringOccurrence, isTrue);

      await box.close();
    });

    test('EndOnDate / EndNever 종료조건 라운드트립', () async {
      final box = await Hive.openBox<TodoModel>('end_conditions_${DateTime.now().microsecondsSinceEpoch}');

      final entity1 = Todo(
        id: 'e1',
        title: 'until',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 1),
        recurrence: RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          end: EndOnDate(DateTime(2025, 3, 1)),
        ),
      );
      final entity2 = Todo(
        id: 'e2',
        title: 'forever',
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 1),
        recurrence: RecurrenceRule(frequency: RecurrenceFrequency.daily),
      );

      await box.put(entity1.id, TodoModel.fromEntity(entity1));
      await box.put(entity2.id, TodoModel.fromEntity(entity2));

      expect(box.get('e1')!.toEntity().recurrence!.end,
          EndOnDate(DateTime(2025, 3, 1)));
      expect(box.get('e2')!.toEntity().recurrence!.end, const EndNever());

      await box.close();
    });
  });
}
