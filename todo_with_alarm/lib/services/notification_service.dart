// services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/app_notification.dart';
import 'package:todo_with_alarm/models/notification_type.dart';

class NotificationService {
  // 싱글톤 패턴 적용
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 알림 채널 정의
  final Map<NotificationType, AndroidNotificationChannel> _channels = {
    NotificationType.todoReminder: AndroidNotificationChannel(
      'daily_todo_reminder_channel',
      'Daily Todo Reminder',
      description: '매일 투두리스트 알림',
      importance: Importance.max,
    ),
    NotificationType.eisenhowerMatrix: AndroidNotificationChannel(
      'daily_important_tasks_channel',
      'Daily Important Tasks',
      description: '매일 중요한 일정 알림',
      importance: Importance.max,
    ),
    NotificationType.goalProgress: AndroidNotificationChannel(
      'weekly_goal_progress_channel',
      'Weekly Goal Progress',
      description: '주간 목표 진행률 알림',
      importance: Importance.max,
    ),
  };

  // 초기화 메서드
  Future<void> initialize(BuildContext context) async {
    // Android 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 초기화 설정
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 전체 초기화 설정
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // 알림 클릭 시 처리 로직
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        // 알림 클릭 시 처리
        if (response.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          _handleNotificationNavigation(response.payload, context);
        }
      },
    );

    // 타임존 초기화
    tz.initializeTimeZones();

    // 알림 채널 생성
    for (var channel in _channels.values) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // 알림 클릭 시 화면 전환 처리 메서드
  void _handleNotificationNavigation(String? payload, BuildContext context) {
    if (payload == null) return;

    NotificationType? type;
    // 문자열로 전달된 타입을 NotificationType으로 변환
    for (var t in NotificationType.values) {
      if (t.toString() == payload) {
        type = t;
        break;
      }
    }

    if (type == null) return;

    // 타입에 따라 화면 전환
    switch (type) {
      case NotificationType.goalProgress:
        Navigator.pushNamed(context, '/progress');
        break;
      case NotificationType.todoReminder:
        Navigator.pushNamed(context, '/todo');
        break;
      case NotificationType.eisenhowerMatrix:
        Navigator.pushNamed(context, '/eisenhower');
        break;
    }
  }

  // 일반적인 알림 스케줄링 메서드
  Future<void> scheduleNotification(AppNotification notification) async {
    // 알림 타입에 따른 채널 선택
    AndroidNotificationChannel channel = _channels[notification.type]!;

    // 알림 ID를 타입에 따라 고유하게 설정 (예: enum의 인덱스 사용)
    int notificationId = notification.type.index;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      notification.title,
      notification.body,
      _convertToTZDateTime(notification.scheduledTime),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: notification.type.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // 반복 설정이 필요하면 추가 설정
    );
  }

  // 즉시 알림 발송 메서드
  Future<void> showNotificationNow(AppNotification notification) async {
    AndroidNotificationChannel channel = _channels[notification.type]!;

    int notificationId = notification.type.index;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: notification.type.toString(),
    );
  }

  // DateTime을 tz.TZDateTime으로 변환하는 함수
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  // 모든 알림 예약 메서드 호출 (예시)
  Future<void> scheduleAllNotifications() async {
    await scheduleNotification(
      AppNotification(
        title: '주간 목표 달성률 분석이 도착했어요!',
        body: '앱을 열어 목표 진행률을 확인해보세요.',
        scheduledTime: _nextInstanceOfMondayAt(12, 0),
        type: NotificationType.goalProgress,
      ),
    );

    await scheduleNotification(
      AppNotification(
        title: '투두리스트를 확인하고 내일을 준비하세요!',
        body: '오늘 투두리스트 수행 여부를 입력하고, 내일의 투두리스트를 작성해보세요.',
        scheduledTime: _nextInstanceOfTime(23, 30),
        type: NotificationType.todoReminder,
      ),
    );

    await scheduleNotification(
      AppNotification(
        title: '오늘의 중요한 일정 확인하세요!',
        body: '중요한 일정을 간단히 정리해드렸어요.',
        scheduledTime: _nextInstanceOfTime(12, 30),
        type: NotificationType.eisenhowerMatrix,
      ),
    );
  }

  // 다음 월요일 특정 시간 계산 함수
  tz.TZDateTime _nextInstanceOfMondayAt(int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 매일 특정 시간 계산 함수
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 즉시 알림 발송 예시 메서드들
  Future<void> showWeeklyGoalProgressNotificationNow() async {
    final notification = AppNotification(
      title: '주간 목표 달성률 분석이 도착했어요!',
      body: '앱을 열어 목표 진행률을 확인해보세요.',
      scheduledTime: DateTime.now(),
      type: NotificationType.goalProgress,
    );

    await showNotificationNow(notification);
  }

  Future<void> showDailyTodoReminderNow() async {
    final notification = AppNotification(
      title: '투두리스트를 확인하고 내일을 준비하세요!',
      body: '오늘 투두리스트 수행 여부를 입력하고, 내일의 투두리스트를 작성해보세요.',
      scheduledTime: DateTime.now(),
      type: NotificationType.todoReminder,
    );

    await showNotificationNow(notification);
  }

  Future<void> showDailyImportantTasksNotificationNow() async {
    final notification = AppNotification(
      title: '오늘의 중요한 일정 확인하세요!',
      body: '중요한 일정을 간단히 정리해드렸어요.',
      scheduledTime: DateTime.now(),
      type: NotificationType.eisenhowerMatrix,
    );

    await showNotificationNow(notification);
  }
}