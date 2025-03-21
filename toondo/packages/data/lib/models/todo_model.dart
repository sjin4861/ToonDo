import 'package:hive/hive.dart';
import 'package:domain/entities/todo.dart';
part 'todo_model.g.dart'; // Hive 어댑터 생성

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? goalId;

  @HiveField(3)
  double status;

  @HiveField(4)
  String comment;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  DateTime endDate;

  @HiveField(7)
  int urgency;

  @HiveField(8)
  int importance;

  @HiveField(9)
  bool isSynced; // 로컬 데이터 동기화 여부

  TodoModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.urgency = 0,
    this.importance = 0,
    this.isSynced = false,
  });

  // New getter and setter for isSynced
  bool get synced => isSynced;
  set synced(bool value) {
    isSynced = value;
    // Optionally persist change: save();
  }

  // ✅ Entity → Model 변환
  factory TodoModel.fromEntity(Todo entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      goalId: entity.goalId,
      status: entity.status,
      comment: entity.comment,
      startDate: entity.startDate,
      endDate: entity.endDate,
      urgency: entity.urgency,
      importance: entity.importance,
      isSynced: false,
    );
  }

  // ✅ Model → Entity 변환
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      goalId: goalId,
      status: status,
      comment: comment,
      startDate: startDate,
      endDate: endDate,
      urgency: urgency,
      importance: importance,
    );
  }

  // ✅ JSON 변환 (API 통신용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'goalId': goalId,
      'status': status,
      'comment': comment,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'urgency': urgency,
      'importance': importance,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      goalId: json['goalId'],
      status: (json['status'] as num).toDouble(),
      comment: json['comment'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      urgency: (json['urgency'] as num).toInt(),
      importance: (json['importance'] as num).toInt(),
      isSynced: true,
    );
  }
}
