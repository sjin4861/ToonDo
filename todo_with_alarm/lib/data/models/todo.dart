// lib/models/todo.dart
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart'; // 제거

part 'todo.g.dart'; // 어댑터 생성 파일

@HiveType(typeId: 0)
class Todo extends HiveObject {
  // 정적 변수 _nextId: 새로운 todo 생성 시마다 증가
  static int _nextId = 1;
  
  @HiveField(0)
  String id; // 투두의 고유 ID

  @HiveField(1)
  String title; // 투두 제목

  @HiveField(2)
  String? goalId; // 연계된 목표의 ID (null 가능)

  @HiveField(3)
  double status; // 0.0 ~ 100.0 사이의 값

  @HiveField(4)
  String comment; // 코멘트

  @HiveField(5)
  DateTime startDate; // 투두의 시작 날짜

  @HiveField(6)
  DateTime endDate; // 투두의 종료 날짜

  @HiveField(7)
  int urgency; // 긴급도 (0 또는 1)

  @HiveField(8)
  int importance; // 중요도 (0 또는 1)

  // 동기화 여부: 서버에 동기화가 완료되었으면 true, 아니면 false.
  @HiveField(9)
  bool isSynced;

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
    this.isSynced = false, // 기본적으로 미동기화 상태
  }) : id = id ?? (_nextId++).toString();

  bool isDDayTodo() {
    return !(startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day);
  }

  bool isFinished() {
    return status == 100.0;
  }

  // JSON으로 변환하는 메서드 (동기화 관련 정보는 서버와 협의하여 필요하면 포함)
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
      // isSynced는 로컬 관리용이므로 보통 서버에는 포함하지 않거나 별도 필드 사용
    };
  }

  void updateFrom(Todo todo) {
    title = todo.title;
    goalId = todo.goalId;
    status = todo.status;
    comment = todo.comment;
    startDate = todo.startDate;
    endDate = todo.endDate;
    urgency = todo.urgency;
    importance = todo.importance;
    isSynced = false; // 수정 시 동기화가 필요하므로 false로 설정
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
      // 서버에서 isSynced 값이 오지 않는다면 기본 false 사용
      isSynced: true,
    );
  }

  Color getBorderColor() {
    if (importance == 1 && urgency == 1) {
      return Colors.red;
    } else if (importance == 1 && urgency == 0) {
      return Colors.blue;
    } else if (importance == 0 && urgency == 1) {
      return Colors.yellow;
    } else {
      return Colors.black;
    }
  }
}