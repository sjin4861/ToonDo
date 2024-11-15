// models/todo.dart

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Todo with ChangeNotifier {
  String id; // 투두의 고유 ID
  String title; // 투두 제목
  String? goalId; // 연계된 목표의 ID (null 가능)
  double status; // 0.0 ~ 100.0 사이의 값
  String comment; // 코멘트
  DateTime startDate; // 투두의 시작 날짜
  DateTime endDate; // 투두의 종료 날짜
  int urgency; // 긴급도 (0 또는 1)
  int importance; // 중요도 (0 또는 1)

  Todo({
    String? id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.goalId,
    this.status = 0.0,
    this.comment = '',
    this.urgency = 0,
    this.importance = 0,
  }) : this.id = id ?? Uuid().v4();

  bool isDDayTodo() {
    return startDate != endDate;
  }

  bool isFinished() {
    return status == 100.0;
  }

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
      urgency: (json['urgency'] as num).toInt(),
      importance: (json['importance'] as num).toInt(),
    );
  }

  Color getBorderColor() {
    if (importance == 1 && urgency == 1) {
      return Colors.red; // 중요도 1, 긴급도 1
    } else if (importance == 1 && urgency == 0) {
      return Colors.blue; // 중요도 1, 긴급도 0
    } else if (importance == 0 && urgency == 1) {
      return Colors.yellow; // 중요도 0, 긴급도 1
    } else {
      return Colors.black; // 중요도 0, 긴급도 0
    }
  }

  
}