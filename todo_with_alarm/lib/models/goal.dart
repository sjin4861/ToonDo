// lib/models/goal.dart

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'goal_status.dart'; // GoalStatus 추가

part 'goal.g.dart'; // TypeAdapter 생성을 위한 부분 파일

@HiveType(typeId: 1) // Hive Type ID 설정
class Goal extends HiveObject {
  @HiveField(0)
  String? id; // 고유 식별자 추가

  @HiveField(1)
  String name; // 목표 이름

  @HiveField(2)
  String? icon; // 아이콘 속성 추가

  @HiveField(3)
  double progress; // 목표 진행률 (0.0 ~ 100.0)

  @HiveField(4)
  DateTime startDate; // 목표 시작일

  @HiveField(5)
  DateTime endDate; // 목표 종료일

  @HiveField(6)
  bool isCompleted; // 목표 완료 여부

  @HiveField(7)
  GoalStatus status; // 상태 필드 추가

  Goal({
    String? id,
    required this.name,
    this.icon, // 아이콘 초기화
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.status = GoalStatus.active, // 기본 상태는 active
  }) : id = id ?? const Uuid().v4(); // UUID 생성

  // 기대 목표 진행률 계산 메서드
  double getExpectedProgress() {
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsedDuration = DateTime.now().difference(startDate).inSeconds;

    if (totalDuration <= 0) {
      return 0.0;
    }

    double expectedProgress = (elapsedDuration / totalDuration) * 100;

    // 진행률은 0%에서 100% 사이로 제한
    if (expectedProgress < 0) {
      return 0.0;
    } else if (expectedProgress > 100) {
      return 100.0;
    } else {
      return expectedProgress;
    }
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon, // 아이콘 추가
      'progress': progress,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
      'status': status.index, // 상태 추가
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      icon: json['icon'], // 아이콘 추가
      progress: (json['progress'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'],      
      status: GoalStatus.values[json['status']], // 상태 추가
    );
  }

  // 목표를 완료 처리하는 함수
  void markAsCompleted() {
    isCompleted = true;
    progress = 100.0;
  }

  // 목표 기간을 업데이트하는 함수
  void updateDuration(DateTime newStartDate, DateTime newEndDate) {
    startDate = newStartDate;
    endDate = newEndDate;
  }

  // 목표 진행률을 업데이트 하는 함수
  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  // 목표의 남은 기간 계산 함수
  Duration getRemainingDuration() {
    return endDate.difference(DateTime.now());
  }

  // 목표 정보 출력 (디버깅 또는 UI 용)
  @override
  String toString() {
    return 'Goal(name: $name, icon: $icon, progress: $progress%, start: $startDate, end: $endDate, completed: $isCompleted, status: $status)';
  }
}
