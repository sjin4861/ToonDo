import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';

/// 루틴 occurrence의 메타 표시 텍스트.
///
/// - [EndNever] → "∞"
/// - [EndOnDate] → D-N / D-Day / D+N (오늘 ↔ 종료일)
/// - [EndAfterCount] → 남은 횟수 (series가 있으면 정확 계산, 없으면 총 횟수)
String? routineSubtitle({
  required Todo occurrence,
  required DateTime selectedDate,
  Todo? series,
}) {
  final end = occurrence.recurrence?.end;
  if (end == null) return null;
  if (end is EndNever) return '∞';
  if (end is EndOnDate) {
    final today = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endDay = DateTime(end.date.year, end.date.month, end.date.day);
    final dDay = endDay.difference(today).inDays;
    if (dDay > 0) return 'D-$dDay';
    if (dDay == 0) return 'D-Day';
    return 'D+${-dDay}';
  }
  if (end is EndAfterCount) {
    final rule = occurrence.recurrence!;
    final total = end.count;
    if (series == null) return '$total회';
    final remaining = _remainingOccurrences(
      series: series,
      rule: rule,
      forDate: selectedDate,
      total: total,
    );
    return '$remaining회';
  }
  return null;
}

/// 1-based occurrence index of [forDate]. remaining = total - index + 1.
/// 주별 반복은 복잡해서 총 횟수 그대로 반환.
int _remainingOccurrences({
  required Todo series,
  required RecurrenceRule rule,
  required DateTime forDate,
  required int total,
}) {
  final start = DateTime(
    series.startDate.year,
    series.startDate.month,
    series.startDate.day,
  );
  final date = DateTime(forDate.year, forDate.month, forDate.day);
  int index;
  switch (rule.frequency) {
    case RecurrenceFrequency.daily:
      final diffDays = date.difference(start).inDays;
      index = diffDays ~/ rule.interval + 1;
      break;
    case RecurrenceFrequency.monthly:
      final monthDiff =
          (date.year - start.year) * 12 + date.month - start.month;
      index = monthDiff ~/ rule.interval + 1;
      break;
    case RecurrenceFrequency.yearly:
      final yearDiff = date.year - start.year;
      index = yearDiff ~/ rule.interval + 1;
      break;
    case RecurrenceFrequency.weekly:
      return total;
  }
  final remaining = total - index + 1;
  if (remaining < 0) return 0;
  if (remaining > total) return total;
  return remaining;
}
