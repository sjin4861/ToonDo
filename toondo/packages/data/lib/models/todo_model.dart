import 'package:hive/hive.dart';
import 'package:domain/entities/todo.dart';
import 'package:data/models/recurrence_rule_model.dart';
part 'todo_model.g.dart';

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
  int eisenhower;

  @HiveField(8)
  bool isSynced;

  @HiveField(9, defaultValue: false)
  bool showOnHome;

  @HiveField(10)
  RecurrenceRuleModel? recurrence;

  @HiveField(11)
  String? seriesId;

  @HiveField(12)
  DateTime? occurrenceDate;

  TodoModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.eisenhower = 0,
    this.isSynced = false,
    this.showOnHome = false,
    this.recurrence,
    this.seriesId,
    this.occurrenceDate,
  });

  bool get synced => isSynced;
  set synced(bool value) {
    isSynced = value;
  }

  factory TodoModel.fromEntity(Todo entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      goalId: entity.goalId,
      status: entity.status,
      comment: entity.comment,
      startDate: entity.startDate,
      endDate: entity.endDate,
      eisenhower: entity.eisenhower,
      showOnHome: entity.showOnHome,
      isSynced: false,
      recurrence: entity.recurrence == null
          ? null
          : RecurrenceRuleModel.fromEntity(entity.recurrence!),
      seriesId: entity.seriesId,
      occurrenceDate: entity.occurrenceDate,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      goalId: goalId,
      status: status,
      comment: comment,
      startDate: startDate,
      endDate: endDate,
      eisenhower: eisenhower,
      showOnHome: showOnHome,
      recurrence: recurrence?.toEntity(),
      seriesId: seriesId,
      occurrenceDate: occurrenceDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'goalId': goalId,
      'status': status,
      'comment': comment,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'eisenhower': eisenhower,
      'showOnHome': showOnHome,
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
      eisenhower: (json['eisenhower'] as num).toInt(),
      showOnHome: json['showOnHome'] ?? false,
      isSynced: true,
    );
  }
}
