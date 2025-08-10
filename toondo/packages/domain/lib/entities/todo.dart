class Todo {
  static int currentId = 1; // Global ID variable

  final String id;
  final String title;
  final String? goalId;
  final double status; // TODO: 서버 API에 따라 0.0(진행) 또는 1.0(완료)만 사용
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
    return status == 1.0; // 서버 API에 맞춰 1.0으로 수정
  }

  // 상태를 토글하는 헬퍼 메서드
  double getToggledStatus() {
    return status == 0.0 ? 1.0 : 0.0;
  }
}
