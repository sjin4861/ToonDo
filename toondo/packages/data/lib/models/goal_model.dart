import 'package:hive/hive.dart';
import 'package:domain/entities/goal.dart';
import 'goal_status.dart'; // ensure this is consistent with your domain
part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
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
  GoalStatus status; // stores the index of GoalStatus

  @HiveField(8)
  bool isSynced;

  GoalModel({
    this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.status = GoalStatus.active,
    this.isSynced = false,
  });

  // Entity → Model conversion
  factory GoalModel.fromEntity(Goal entity) {
    return GoalModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      progress: entity.progress,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isCompleted: entity.isCompleted,
      status: entity.status as GoalStatus,
      isSynced: false,
    );
  }

  // Model → Entity conversion
  Goal toEntity() {
    return Goal(
      id: id,
      name: name,
      icon: icon,
      progress: progress,
      startDate: startDate,
      endDate: endDate,
      isCompleted: isCompleted,
      status: status as GoalStatus,
    );
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
      'status': status,
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      progress: (json['progress'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],
      status: json['status'],
      isSynced: true,
    );
  }

  double getExpectedProgress() {
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsedDuration = DateTime.now().difference(startDate).inSeconds;
    if (totalDuration <= 0) return 0.0;
    double expectedProgress = (elapsedDuration / totalDuration) * 100;
    return expectedProgress.clamp(0.0, 100.0) as double;
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
