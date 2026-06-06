import 'package:domain/entities/recurrence_rule.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpandRecurringTodosForDateUseCase {
  final TodoRepository repository;

  ExpandRecurringTodosForDateUseCase(this.repository);

  Future<List<Todo>> call(DateTime targetDate) async {
    final dayOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final series = await repository.getRecurringSeries();
    final result = <Todo>[];
    for (final s in series) {
      if (!_isOccurrence(s, dayOnly)) continue;
      final materialized = await repository.findOccurrence(
        seriesId: s.id,
        occurrenceDate: dayOnly,
      );
      result.add(materialized ?? _virtualOccurrence(s, dayOnly));
    }
    return result;
  }

  Todo _virtualOccurrence(Todo series, DateTime date) {
    return Todo(
      id: '${series.id}@${date.toIso8601String()}',
      title: series.title,
      goalId: series.goalId,
      startDate: date,
      endDate: date,
      comment: series.comment,
      eisenhower: series.eisenhower,
      showOnHome: series.showOnHome,
      recurrence: series.recurrence,
      seriesId: series.id,
      occurrenceDate: date,
    );
  }

  bool _isOccurrence(Todo series, DateTime date) {
    final rule = series.recurrence!;
    final start = DateTime(
      series.startDate.year,
      series.startDate.month,
      series.startDate.day,
    );
    if (date.isBefore(start)) return false;
    if (!_isBeforeEnd(rule.end, date, start)) return false;

    switch (rule.frequency) {
      case RecurrenceFrequency.daily:
        final diffDays = date.difference(start).inDays;
        if (diffDays % rule.interval != 0) return false;
        return _isWithinCount(rule.end, diffDays ~/ rule.interval + 1);
      case RecurrenceFrequency.weekly:
        final weekdays = rule.byWeekdays.isEmpty
            ? [start.weekday]
            : rule.byWeekdays;
        if (!weekdays.contains(date.weekday)) return false;
        final weekDiff = _weeksBetween(start, date);
        if (weekDiff % rule.interval != 0) return false;
        if (rule.end is EndAfterCount) {
          final count = (rule.end as EndAfterCount).count;
          final occurrence = _occurrenceIndexWeekly(
            start: start,
            date: date,
            weekdays: weekdays,
            interval: rule.interval,
          );
          return occurrence <= count;
        }
        return true;
      case RecurrenceFrequency.monthly:
        final day = rule.byMonthDay ?? start.day;
        if (date.day != day) return false;
        final monthDiff = (date.year - start.year) * 12 + date.month - start.month;
        if (monthDiff < 0 || monthDiff % rule.interval != 0) return false;
        return _isWithinCount(rule.end, monthDiff ~/ rule.interval + 1);
      case RecurrenceFrequency.yearly:
        if (date.month != start.month || date.day != start.day) return false;
        final yearDiff = date.year - start.year;
        if (yearDiff < 0 || yearDiff % rule.interval != 0) return false;
        return _isWithinCount(rule.end, yearDiff ~/ rule.interval + 1);
    }
  }

  bool _isBeforeEnd(RecurrenceEnd end, DateTime date, DateTime start) {
    switch (end) {
      case EndNever():
        return true;
      case EndOnDate(date: final endDate):
        final endDay = DateTime(endDate.year, endDate.month, endDate.day);
        return !date.isAfter(endDay);
      case EndAfterCount():
        return true;
    }
  }

  bool _isWithinCount(RecurrenceEnd end, int occurrenceIndex) {
    if (end is EndAfterCount) return occurrenceIndex <= end.count;
    if (end is EndOnDate) return true;
    return true;
  }

  int _weeksBetween(DateTime start, DateTime date) {
    final startWeekStart = start.subtract(Duration(days: start.weekday % 7));
    final dateWeekStart = date.subtract(Duration(days: date.weekday % 7));
    return dateWeekStart.difference(startWeekStart).inDays ~/ 7;
  }

  int _occurrenceIndexWeekly({
    required DateTime start,
    required DateTime date,
    required List<int> weekdays,
    required int interval,
  }) {
    var count = 0;
    var cursor = start;
    while (!cursor.isAfter(date)) {
      final weekDiff = _weeksBetween(start, cursor);
      if (weekDiff % interval == 0 && weekdays.contains(cursor.weekday)) {
        count++;
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return count;
  }
}
