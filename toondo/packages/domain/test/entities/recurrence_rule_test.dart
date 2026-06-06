import 'package:flutter_test/flutter_test.dart';
import 'package:domain/entities/recurrence_rule.dart';

void main() {
  group('RecurrenceRule', () {
    test('기본값으로 생성되어야 한다', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily);
      expect(rule.interval, 1);
      expect(rule.byWeekdays, isEmpty);
      expect(rule.byMonthDay, isNull);
      expect(rule.end, const EndNever());
    });

    test('동일 값 규칙은 같아야 한다', () {
      final a = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        byWeekdays: const [1, 3, 5],
        end: const EndAfterCount(10),
      );
      final b = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        byWeekdays: const [1, 3, 5],
        end: const EndAfterCount(10),
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith로 일부 필드만 변경 가능', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily);
      final updated = rule.copyWith(interval: 3);
      expect(updated.frequency, RecurrenceFrequency.daily);
      expect(updated.interval, 3);
    });
  });

  group('RecurrenceEnd', () {
    test('EndOnDate 동일 날짜는 같아야 한다', () {
      expect(EndOnDate(DateTime(2025, 1, 1)), EndOnDate(DateTime(2025, 1, 1)));
    });
    test('EndAfterCount 동일 횟수는 같아야 한다', () {
      expect(const EndAfterCount(5), const EndAfterCount(5));
      expect(const EndAfterCount(5) == const EndAfterCount(6), isFalse);
    });
  });
}
