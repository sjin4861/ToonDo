// models/goal.dart

class Goal {
  String name; // 목표 이름
  double progress; // 목표 진행률 (0.0 ~ 100.0)
  DateTime startDate; // 목표 설정 시작일
  DateTime endDate; // 목표 설정 종료일
  bool isCompleted; // 목표 성취 여부

  Goal({
    required this.name,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'progress': progress,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'],
      progress: json['progress'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],
    );
  }

  // 목표 진행률을 업데이트하는 함수
  void updateProgress(double newProgress) {
    if (newProgress >= 0.0 && newProgress <= 100.0) {
      progress = newProgress;
      if (progress == 100.0) {
        isCompleted = true;
      }
    }
  }

  // 목표를 완료 처리하는 함수
  void markAsCompleted() {
    isCompleted = true;
    progress = 100.0;
  }

  // 목표 기간을 업데이트하는 함수
  void updateDuration(DateTime newStartDate, DateTime newEndDate) {
    startDate = newStartDate;
    endDate = newEndDate;
  }

  // 목표의 남은 기간 계산 함수
  Duration getRemainingDuration() {
    return endDate.difference(DateTime.now());
  }

  // 목표 정보 출력 (디버깅 또는 UI 용)
  @override
  String toString() {
    return 'Goal(name: $name, progress: $progress%, start: $startDate, end: $endDate, completed: $isCompleted)';
  }
}