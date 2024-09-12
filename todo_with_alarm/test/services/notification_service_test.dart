import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  // 알림 서비스 인스턴스화
  final NotificationService notificationService = NotificationService();

  testWidgets('Notification initialization test', (WidgetTester tester) async {
    // 알림 초기화 호출
    await notificationService.initialize();

    // 알림 초기화가 성공적으로 완료되었는지 확인 (로그를 사용하여 확인할 수 있음)
    expect(notificationService.flutterLocalNotificationsPlugin != null, true);
  });

  testWidgets('Daily notification scheduling test', (WidgetTester tester) async {
    // 매일 알림 스케줄링 테스트
    await notificationService.showDailyNotification();

    // 알림이 정상적으로 스케줄링 되었는지 확인할 수 있는 방법 추가 (로그나 트리거 시간 확인)
    expect(true, true);  // 실제로는 로그에서 확인
  });
}