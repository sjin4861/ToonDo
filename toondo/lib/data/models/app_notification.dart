// models/app_notification.dart

import 'package:toondo/data/models/notification_type.dart';

class AppNotification {
  String title;                 // 알림 제목
  String body;                  // 알림 내용
  DateTime scheduledTime;       // 알림 예정 시간
  NotificationType type;        // 알림 타입 추가

  AppNotification({
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
  });

  // 남은 시간을 반환하는 함수
  Duration getRemainingTime() {
    return scheduledTime.difference(DateTime.now());
  }

  // 알림 정보를 문자열로 출력
  @override
  String toString() {
    return 'Notification(title: $title, body: $body, scheduledTime: $scheduledTime, type: $type)';
  }
}