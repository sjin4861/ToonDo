// models/todo.dart

import 'package:flutter/foundation.dart';

class Todo with ChangeNotifier {
  String title; // 투두 제목
  String? goalId; // 연계된 목표의 ID (null 가능)updateStatus
  double status; // 0.0 ~ 100.0 사이의 값
  String comment; // 코멘트
  DateTime date; // 투두의 날짜
  double urgency; // 긴급도 (0.0 ~ 10.0)
  double importance; // 중요도 (0.0 ~ 10.0)

  Todo({
    required this.title,
    required this.date,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.urgency = 0.0,
    this.importance = 0.0,
  });

  // 진행률 업데이트 메서드 추가
  void updateStatus(double newStatus) {
    status = newStatus;
    notifyListeners();
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'goalId': goalId, // 목표 필드 추가
      'status': status,
      'comment': comment,
      'date': date.toIso8601String(),
      'urgency': urgency,
      'importance': importance,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      date: DateTime.parse(json['date']),
      goalId: json['goalId'], // 목표 필드 추가
      status: (json['status'] as num).toDouble(),
      comment: json['comment'],
      urgency: (json['urgency'] as num).toDouble(),
      importance: (json['importance'] as num).toDouble(),
    );
  }
}