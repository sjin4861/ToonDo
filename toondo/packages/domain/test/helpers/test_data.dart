import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';

class TestData {
  // 테스트용 목표 생성 (ID만 변경하여 여러 개의 목표 생성 가능)
  static Goal createTestGoal({
    required String id,
    String name = '테스트 목표',
    String? icon,
    double progress = 0.0,
    DateTime? startDate,
    DateTime? endDate,
    Status status = Status.active,
  }) {
    return Goal(
      id: id,
      name: name,
      icon: icon,
      progress: progress,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      status: status,
    );
  }

  // 테스트용 목표 목록 생성
  static List<Goal> createTestGoals({int count = 3}) {
    return List.generate(
      count,
      (index) => createTestGoal(
        id: 'goal_$index',
        name: '테스트 목표 $index',
        progress: index * 0.2,
      ),
    );
  }
}