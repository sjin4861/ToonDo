// models/todo.dart

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Todo with ChangeNotifier {
  String id; // 투두의 고유 ID
  String title; // 투두 제목
  String? goalId; // 연계된 목표의 ID (null 가능)
  double status; // 0.0 ~ 100.0 사이의 값
  String comment; // 코멘트
  DateTime startDate; // 투두의 시작 날짜
  DateTime endDate; // 투두의 종료 날짜
  double urgency; // 긴급도 (0.0 ~ 10.0)
  double importance; // 중요도 (0.0 ~ 10.0)

  Todo({
    String? id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.urgency = 0.0,
    this.importance = 0.0,
  }) : this.id = id ?? Uuid().v4();

  // 진행률 업데이트 메서드
  void updateStatus(double newStatus) {
    status = newStatus;
    notifyListeners();
  }

  // JSON으로 변환하는 메서드
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

  // JSON에서 객체로 변환하는 메서드
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      goalId: json['goalId'],
      status: (json['status'] as num).toDouble(),
      comment: json['comment'],
      urgency: (json['urgency'] as num).toDouble(),
      importance: (json['importance'] as num).toDouble(),
    );
  }
}