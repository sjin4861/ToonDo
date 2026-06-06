import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/expand_recurring_todos_for_date.dart';
import '../../mocks/mock_todo_repository.dart';

Todo _series({
  required String id,
  required DateTime start,
  required RecurrenceRule rule,
}) {
  return Todo(
    id: id,
    title: 'series-$id',
    startDate: start,
    endDate: start,
    recurrence: rule,
  );
}

void main() {
  late MockTodoRepository repo;
  late ExpandRecurringTodosForDateUseCase useCase;

  setUp(() {
    repo = MockTodoRepository();
    useCase = ExpandRecurringTodosForDateUseCase(repo);
  });

  group('Daily', () {
    test('매일 반복이면 시작일 이후 모든 날에 인스턴스 생성', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 1),
        rule: RecurrenceRule(frequency: RecurrenceFrequency.daily),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      final result = await useCase.call(DateTime(2025, 1, 5));
      expect(result, hasLength(1));
      expect(result.first.seriesId, 's1');
      expect(result.first.occurrenceDate, DateTime(2025, 1, 5));
    });

    test('격일 반복(interval=2)은 짝수 일차에만 발생', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 1),
        rule: RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          interval: 2,
        ),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 1, 1)), hasLength(1));
      expect(await useCase.call(DateTime(2025, 1, 2)), isEmpty);
      expect(await useCase.call(DateTime(2025, 1, 3)), hasLength(1));
    });

    test('시작일 이전 날짜는 빈 결과', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 10),
        rule: RecurrenceRule(frequency: RecurrenceFrequency.daily),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 1, 1)), isEmpty);
    });
  });

  group('Weekly', () {
    test('매주 월/수/금에만 발생', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 6), // Mon
        rule: RecurrenceRule(
          frequency: RecurrenceFrequency.weekly,
          byWeekdays: [1, 3, 5],
        ),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 1, 6)), hasLength(1)); // Mon
      expect(await useCase.call(DateTime(2025, 1, 7)), isEmpty); // Tue
      expect(await useCase.call(DateTime(2025, 1, 8)), hasLength(1)); // Wed
      expect(await useCase.call(DateTime(2025, 1, 13)), hasLength(1)); // 다음 Mon
    });
  });

  group('Monthly', () {
    test('매달 같은 날 발생', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 15),
        rule: RecurrenceRule(frequency: RecurrenceFrequency.monthly),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 2, 15)), hasLength(1));
      expect(await useCase.call(DateTime(2025, 2, 16)), isEmpty);
      expect(await useCase.call(DateTime(2025, 3, 15)), hasLength(1));
    });
  });

  group('End conditions', () {
    test('EndOnDate 이후 날짜는 발생하지 않음', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 1),
        rule: RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          end: EndOnDate(DateTime(2025, 1, 3)),
        ),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 1, 3)), hasLength(1));
      expect(await useCase.call(DateTime(2025, 1, 4)), isEmpty);
    });

    test('EndAfterCount: N회 이후 발생하지 않음', () async {
      final series = _series(
        id: 's1',
        start: DateTime(2025, 1, 1),
        rule: RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          end: const EndAfterCount(3),
        ),
      );
      when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);

      expect(await useCase.call(DateTime(2025, 1, 3)), hasLength(1));
      expect(await useCase.call(DateTime(2025, 1, 4)), isEmpty);
    });
  });

  test('이미 머터리얼라이즈된 인스턴스가 있으면 그것을 우선 반환', () async {
    final series = _series(
      id: 's1',
      start: DateTime(2025, 1, 1),
      rule: RecurrenceRule(frequency: RecurrenceFrequency.daily),
    );
    final materialized = Todo(
      id: 'mat-1',
      title: 'series-s1',
      startDate: DateTime(2025, 1, 5),
      endDate: DateTime(2025, 1, 5),
      status: 1.0,
      seriesId: 's1',
      occurrenceDate: DateTime(2025, 1, 5),
    );
    when(repo.getRecurringSeries()).thenAnswer((_) async => [series]);
    when(repo.findOccurrence(
      seriesId: 's1',
      occurrenceDate: DateTime(2025, 1, 5),
    )).thenAnswer((_) async => materialized);

    final result = await useCase.call(DateTime(2025, 1, 5));
    expect(result.single.id, 'mat-1');
    expect(result.single.status, 1.0);
  });
}
