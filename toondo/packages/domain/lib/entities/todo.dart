class Todo {
  static int currentId = 1; // Global ID variable

  final String id;
  final String title;
  final String? goalId;
  final double status;
  final String comment;
  final DateTime startDate;
  final DateTime endDate;
  final int eisenhower; // TODO: 0,1,2,3 인지 1,2,3,4 인지 서버 API 스펙 확인 필요

  Todo({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.eisenhower = 0,
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
