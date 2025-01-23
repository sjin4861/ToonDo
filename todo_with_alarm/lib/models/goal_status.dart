// lib/models/goal_status.dart

import 'package:hive/hive.dart';

part 'goal_status.g.dart'; // TypeAdapter 생성을 위한 부분 파일

@HiveType(typeId: 2) // 고유한 typeId 할당 (Goal 클래스의 typeId가 1이므로 2 사용)
enum GoalStatus {
  @HiveField(0)
  active,

  @HiveField(1)
  completed,

  @HiveField(2)
  givenUp,
}
/// 이 Extension은 GoalStatus의 성격에 따라 쉽게 분류할 수 있게 해줍니다.
extension GoalStatusExtension on GoalStatus {
  /// "진행 중" 범주(= 아직 완료나 포기가 아님)
  bool get isInProgress => this == GoalStatus.active;

  /// "진행 완료" 범주(= 완료거나 포기)
  bool get isCompleted => this == GoalStatus.completed || this == GoalStatus.givenUp;
}