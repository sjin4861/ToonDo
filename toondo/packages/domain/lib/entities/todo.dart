import 'package:domain/entities/recurrence_rule.dart';

class Todo {
  static int currentId = 1;

  final String id;
  final String title;
  final String? goalId;
  final double status;
  final String comment;
  final DateTime startDate;
  final DateTime endDate;
  final int eisenhower;
  final bool showOnHome;

  final RecurrenceRule? recurrence;
  final String? seriesId;
  final DateTime? occurrenceDate;

  Todo({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.eisenhower = 0,
    this.showOnHome = false,
    this.recurrence,
    this.seriesId,
    this.occurrenceDate,
  });

  bool isDDayTodo() {
    return !(startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day);
  }

  bool isFinished() {
    return status == 1.0;
  }

  double getToggledStatus() {
    return status == 0.0 ? 1.0 : 0.0;
  }

  bool get isRecurring => recurrence != null;

  bool get isRecurringSeries => isRecurring && seriesId == null;

  bool get isRecurringOccurrence => seriesId != null && occurrenceDate != null;
}
