// lib/models/goal.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'goal_status.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? icon;

  @HiveField(3)
  double progress;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  GoalStatus status;

  // 동기화 여부 플래그 추가
  @HiveField(8)
  bool isSynced;

  Goal({
    String? id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.status = GoalStatus.active,
    this.isSynced = false, // 기본적으로 미동기화 상태
  }) : id = id ?? const Uuid().v4();

  double getExpectedProgress() {
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsedDuration = DateTime.now().difference(startDate).inSeconds;
    if (totalDuration <= 0) {
      return 0.0;
    }
    double expectedProgress = (elapsedDuration / totalDuration) * 100;
    if (expectedProgress < 0) {
      return 0.0;
    } else if (expectedProgress > 100) {
      return 100.0;
    } else {
      return expectedProgress;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'progress': progress,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
      'status': status.index,
      // 보통 isSynced는 서버와 관리하지 않으므로 제외하거나 별도 처리
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      progress: (json['progress'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],
      status: GoalStatus.values[json['status']],
      isSynced: false,
    );
  }

  void markAsCompleted() {
    isCompleted = true;
    progress = 100.0;
  }

  void updateDuration(DateTime newStartDate, DateTime newEndDate) {
    startDate = newStartDate;
    endDate = newEndDate;
  }

  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  Duration getRemainingDuration() {
    return endDate.difference(DateTime.now());
  }

  @override
  String toString() {
    return 'Goal(name: $name, icon: $icon, progress: $progress%, start: $startDate, end: $endDate, completed: $isCompleted, status: $status)';
  }
}