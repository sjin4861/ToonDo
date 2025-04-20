// lib/models/goal_status.dart

import 'package:hive/hive.dart';

part 'goal_status_enum.g.dart'; // TypeAdapter 생성을 위한 부분 파일

@HiveType(typeId: 2)
enum GoalStatusEnum {
  @HiveField(0)
  active,

  @HiveField(1)
  completed,

  @HiveField(2)
  givenUp,
}
