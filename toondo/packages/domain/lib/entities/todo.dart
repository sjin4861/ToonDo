class Todo {
  static int currentId = 1; // Global ID variable

  final String id;
  final String title;
  final String? goalId;
  final double status;
  final String comment;
  final DateTime startDate;
  final DateTime endDate;
  final int urgency;
  final int importance;

  Todo({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.urgency = 0,
    this.importance = 0,
  });

  bool isDDayTodo() {
    return !(startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day);
  }

  bool isFinished() {
    return status == 100.0;
  }
}
