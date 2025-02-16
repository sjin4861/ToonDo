import 'package:uuid/uuid.dart';
import 'goal_status.dart'; // domain enum

class Goal {
  String id;
  String name;
  String? icon;
  double progress;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;
  GoalStatus status;

  Goal({
    String? id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.status = GoalStatus.active,
  }) : id = id ?? const Uuid().v4();
}
