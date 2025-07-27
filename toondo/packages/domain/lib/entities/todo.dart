class Todo {
  static int currentId = 1; // Global ID variable

  final String id;
  final String title;
  final String? goalId;
  final double status;
  final String comment;
  final DateTime startDate;
  final DateTime endDate;
  final int eisenhower;
  // NOTE: 없애야하는데 에러 수정을 위해 임시로 놔둠
  final int urgency; // 긴급도
  final int importance; // 중요도

  Todo({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.eisenhower = 0,
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
