import 'package:data/utils/goal_status_mapper.dart';
import 'package:hive/hive.dart';
import 'package:domain/entities/goal.dart';
import 'package:data/models/goal_status_enum.dart';
part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  @HiveField(0)
  String id;

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
  GoalStatusEnum status; // stores the index of GoalStatus

  @HiveField(8)
  bool isSynced;

  GoalModel({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.status = GoalStatusEnum.active,
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
      status: GoalStatusMapper.fromDomain(entity.status),
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
      status: GoalStatusMapper.toDomain(status),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalId': id,
      'goalName': name,
      'icon': icon,
      'progress': progress,
      'startDate': startDate.toIso8601String().split('T')[0], // yyyy-MM-dd 형식으로 변환
      'endDate': endDate.toIso8601String().split('T')[0],
      'status': status.index,  // 열거형의 인덱스 전송
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['icon'] as String?;
    String? normalizedIcon;
    if (rawIcon != null) {
      if (rawIcon.startsWith('assets/')) {
        normalizedIcon = rawIcon;
      } else {
        // ensure 'ic_' prefix and asset path
        final fileName = rawIcon.startsWith('ic_') ? rawIcon : 'ic_$rawIcon';
        normalizedIcon = 'assets/icons/$fileName';
      }
    }
    return GoalModel(
      id: json['goalId'].toString(), // 변경: 'id' 대신 'goalId'
      name: json['goalName'],        // 변경: 'name' 대신 'goalName'
      icon: normalizedIcon,
      progress: (json['progress'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: false,            // API에서 isCompleted 미전달 시 기본값 사용
      status: json['status'] != null
          ? GoalStatusEnum.values[json['status']]
          : GoalStatusEnum.active,       // null인 경우 기본값 처리
      isSynced: true,
    );
  }

  double getExpectedProgress() {
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsedDuration = DateTime.now().difference(startDate).inSeconds;
    if (totalDuration <= 0) return 0.0;
    final double expectedProgress = (elapsedDuration / totalDuration) * 100;
    return expectedProgress.clamp(0.0, 100.0);
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
    return 'Goal(id: $id, name: $name, icon: $icon, progress: $progress, startDate: $startDate, endDate: $endDate)';
  }
}
