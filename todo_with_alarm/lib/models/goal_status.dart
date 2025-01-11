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