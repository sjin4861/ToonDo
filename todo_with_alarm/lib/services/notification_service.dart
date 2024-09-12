import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_with_alarm/models/notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 초기화 설정
    final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        notificationCategories: [
          DarwinNotificationCategory(
            'demoCategory',
            actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain('id_1', 'Action 1'),
                DarwinNotificationAction.plain(
                'id_2',
                'Action 2',
                options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.destructive,
                },
                ),
                DarwinNotificationAction.plain(
                'id_3',
                'Action 3',
                options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.foreground,
                },
                ),
            ],
            options: <DarwinNotificationCategoryOption>{
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
        ),
        ]
      );

    // 전체 초기화 설정
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    @pragma('vm:entry-point')
    void notificationTapBackground(NotificationResponse notificationResponse) {
      // handle action
    }

    // 플러그인 초기화
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // 알림 클릭 시 처리 로직
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // iOS 권한 요청
    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

    // 타임존 초기화
    tz.initializeTimeZones();
  }

  // 특정 시간에 알림을 예약하는 함수
  Future<void> scheduleNotification(AppNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_channel_id', // 채널 ID
      'Scheduled Notifications', // 채널 이름
      channelDescription: 'Scheduled notification to remind you of your tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // 알림 시간 설정을 TimeZone을 사용하여 처리
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 알림 ID
      notification.title, // 알림 제목
      notification.body, // 알림 내용
      tz.TZDateTime.from(notification.scheduledTime, tz.local), // 시간대 설정
      platformChannelSpecifics,
      androidAllowWhileIdle: true, // 절전 모드에서도 알림 허용
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 매일 같은 시간에 알림을 예약하는 함수
  Future<void> showDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_channel_id', // 채널 ID
      'Daily Notifications', // 채널 이름
      channelDescription: 'Daily notification to remind you of your tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // 매일 12시 30분에 알림 예약 (TimeZone을 사용하여 시간 처리)
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '목표 진행률 분석이 도착했어요!',
      '앱을 열어 목표를 확인해보세요.',
      _nextInstanceOfTime(12, 30), // 매일 12:30 PM 알림 예약
      // _nextInstanceOfTime(15, 00), // 매일 12:30 PM 알림 예약
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간
    );
  }

  // 매일 특정 시간을 계산하는 함수
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // NotificationService 클래스에 추가할 코드
  Future<void> showImmediateNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'immediate_channel_id', // 채널 ID
      'Immediate Notifications', // 채널 이름
      channelDescription: 'Immediate notification for testing',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // 즉시 알림 발송
    await flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      '즉시 알림', // 알림 제목
      '이것은 테스트 알림입니다.', // 알림 내용
      platformChannelSpecifics,
    );
  }
}