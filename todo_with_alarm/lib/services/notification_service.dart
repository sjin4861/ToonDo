// services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_with_alarm/models/notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart'; // 화면 전환을 위해 필요

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 초기화 메서드 수정
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // 알림 클릭 시 처리
        if (response.notificationResponseType == NotificationResponseType.selectedNotification) {
          _handleNotificationNavigation(response.payload, context);
        }
      },
    );

    // 타임존 초기화
    tz.initializeTimeZones();

    // 모든 필요한 알림 채널 생성
    const List<AndroidNotificationChannel> channels = [
      AndroidNotificationChannel(
        'weekly_goal_progress_channel', // 채널 ID
        'Weekly Goal Progress', // 채널 이름
        description: '주간 목표 진행률 알림', // 채널 설명
        importance: Importance.max,
      ),
      AndroidNotificationChannel(
        'daily_todo_reminder_channel',
        'Daily Todo Reminder',
        description: '매일 투두리스트 알림',
        importance: Importance.max,
      ),
      AndroidNotificationChannel(
        'daily_important_tasks_channel',
        'Daily Important Tasks',
        description: '매일 중요한 일정 알림',
        importance: Importance.max,
      ),
      AndroidNotificationChannel(
        'immediate_channel_id',
        'Immediate Notifications',
        description: 'Immediate notification for testing',
        importance: Importance.max,
      ),
    ];
    
    for (var channel in channels) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // 알림 클릭 시 화면 전환 처리 메서드
  void _handleNotificationNavigation(String? payload, BuildContext context) {
    if (payload == null) return;

    // payload에 따라 해당 화면으로 이동
    switch (payload) {
      case 'goal_progress':
        Navigator.pushNamed(context, '/progress');
        break;
      case 'todo_list':
        Navigator.pushNamed(context, '/todo');
        break;
      case 'eisenhower_matrix':
        Navigator.pushNamed(context, '/eisenhower');
        break;
      default:
        break;
    }
  }

  // 주간 목표 진행률 알림 예약 메서드
  Future<void> scheduleWeeklyGoalProgressNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // 알림 ID
      '주간 목표 달성률 분석이 도착했어요!',
      '앱을 열어 목표 진행률을 확인해보세요.',
      _nextInstanceOfMondayAt(12, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_goal_progress_channel',
          'Weekly Goal Progress',
          channelDescription: '주간 목표 진행률 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'goal_progress',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  // 매일 투두리스트 알림 예약 메서드
  Future<void> scheduleDailyTodoReminder() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2, // 알림 ID
      '투두리스트를 확인하고 내일을 준비하세요!',
      '오늘 투두리스트 수행 여부를 입력하고, 내일의 투두리스트를 작성해보세요.',
      _nextInstanceOfTime(23, 30),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_todo_reminder_channel',
          'Daily Todo Reminder',
          channelDescription: '매일 투두리스트 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'todo_list',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // 매일 중요한 일정 알림 예약 메서드
  Future<void> scheduleDailyImportantTasksNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      3, // 알림 ID
      '오늘의 중요한 일정 확인하세요!',
      '중요한 일정을 간단히 정리해드렸어요.',
      _nextInstanceOfTime(12, 30),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_important_tasks_channel',
          'Daily Important Tasks',
          channelDescription: '매일 중요한 일정 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'eisenhower_matrix',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
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

  // 모든 알림 예약 메서드 호출
  Future<void> scheduleAllNotifications() async {
    await scheduleWeeklyGoalProgressNotification();
    await scheduleDailyTodoReminder();
    await scheduleDailyImportantTasksNotification();
  }

  // 주간 목표 진행률 알림 즉시 발송 메서드
  Future<void> showWeeklyGoalProgressNotificationNow() async {
    await flutterLocalNotificationsPlugin.show(
      1, // 알림 ID
      '주간 목표 달성률 분석이 도착했어요!',
      '앱을 열어 목표 진행률을 확인해보세요.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_goal_progress_channel',
          'Weekly Goal Progress',
          channelDescription: '주간 목표 진행률 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'goal_progress',
    );
  }

  // 투두리스트 알림 즉시 발송 메서드
  Future<void> showDailyTodoReminderNow() async {
    await flutterLocalNotificationsPlugin.show(
      2, // 알림 ID
      '투두리스트를 확인하고 내일을 준비하세요!',
      '오늘 투두리스트 수행 여부를 입력하고, 내일의 투두리스트를 작성해보세요.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_todo_reminder_channel',
          'Daily Todo Reminder',
          channelDescription: '매일 투두리스트 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'todo_list',
    );
  }

  // 중요한 일정 알림 즉시 발송 메서드
  Future<void> showDailyImportantTasksNotificationNow() async {
    await flutterLocalNotificationsPlugin.show(
      3, // 알림 ID
      '오늘의 중요한 일정 확인하세요!',
      '중요한 일정을 간단히 정리해드렸어요.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_important_tasks_channel',
          'Daily Important Tasks',
          channelDescription: '매일 중요한 일정 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'eisenhower_matrix',
    );
  }

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