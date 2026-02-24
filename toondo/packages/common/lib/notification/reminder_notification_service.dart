import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

@lazySingleton
class ReminderNotificationService {
  ReminderNotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _inited = false;

  static const _channelId   = 'toondo_reminder_v2';
  static const _channelName = 'Toondo Reminder v2';
  static const _channelDesc = 'Daily reminder notifications';
  static const _reminderId  = 1001;

  String _tzIdFrom(dynamic raw) {
    if (raw is String) return raw;
    try {
      final id = (raw as dynamic).identifier;
      if (id is String && id.isNotEmpty) return id;
    } catch (_) {}
    return raw.toString();
  }

  Future<void> init() async {
    if (_inited) return;
    _inited = true;

    tz.initializeTimeZones();
    try {
      final raw = await FlutterTimezone.getLocalTimezone();
      final String tzId = _tzIdFrom(raw);
      tz.setLocalLocation(tz.getLocation(tzId));
    } catch (e) {
      tz.setLocalLocation(tz.local);
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit     = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    ));
  }

  /// "오전 08:30" / "오후 07:05" / "08:30" (24시간) 모두 지원
  TimeOfDay _parseTimeFlexible(String input) {
    final s = input.trim();

    if (s.startsWith('오전') || s.startsWith('오후')) {
      final isAm = s.startsWith('오전');
      final rest = s.substring(2).trim();
      final parts = rest.split(':');
      var h = int.tryParse(parts[0]) ?? 9;
      final m = int.tryParse(parts[1]) ?? 0;
      if (!isAm && h < 12) h += 12;
      if (isAm && h == 12) h = 0;
      return TimeOfDay(hour: h, minute: m);
    }

    final upper = s.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      final isAm = upper.contains('AM');
      final hm = upper.replaceAll(RegExp('[^0-9:]'), '');
      final parts = hm.split(':');
      var h = int.tryParse(parts[0]) ?? 9;
      final m = int.tryParse(parts[1]) ?? 0;
      if (!isAm && h < 12) h += 12;
      if (isAm && h == 12) h = 0;
      return TimeOfDay(hour: h, minute: m);
    }

    final parts = s.split(':');
    final h = int.tryParse(parts[0]) ?? 9;
    final m = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  tz.TZDateTime _nextAt(TimeOfDay t) {
    final now = tz.TZDateTime.now(tz.local);
    var dt = tz.TZDateTime(tz.local, now.year, now.month, now.day, t.hour, t.minute);
    if (dt.isBefore(now)) dt = dt.add(const Duration(days: 1));
    return dt;
  }

  /// 예약 취소 (해당 리마인더만)
  Future<void> cancelReminder() => _plugin.cancel(_reminderId);

  /// 토글/시간/사운드에 맞춰 예약 갱신
  Future<void> sync({
    required bool enabledAll,
    required bool enabledReminder,
    required bool soundOn,
    required String timeHHmm,
    String? title,
    String? body,
  }) async {
    await init();

    // NOTE:
    // 일부 릴리즈 빌드에서 R8/ProGuard로 인해 flutter_local_notifications 내부 Gson TypeToken이
    // `TypeToken must be created with a type argument` 예외를 던질 수 있습니다.
    // 이 경우 알림 동기화 때문에 앱 부팅이 막히지 않도록 best-effort로 실패를 흡수합니다.
    bool _isTypeTokenShrinkerIssue(Object e) {
      if (e is PlatformException) {
        final msg = (e.message ?? '').toLowerCase();
        return msg.contains('typetoken') && msg.contains('type argument');
      }
      return false;
    }

    if (!enabledReminder) {
      try {
        await cancelReminder();
      } catch (e) {
        if (_isTypeTokenShrinkerIssue(e)) {
          debugPrint('[Reminder] cancel failed due to shrinker TypeToken issue (ignored): $e');
          return;
        }
        rethrow;
      }
      return;
    }

    final tod = _parseTimeFlexible(timeHHmm);
    final fireAt = _nextAt(tod);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundOn,
        enableVibration: soundOn,
        icon: '@drawable/ic_logo',
        color: Color(0xFFA0CD79),
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
        ticker: 'toondo reminder',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: soundOn,
        presentBadge: true,
      ),
    );

    debugPrint('[Reminder] scheduling local=$fireAt tz=${tz.local.name} sound=$soundOn');

    try {
      await _plugin.zonedSchedule(
        _reminderId,
        title ?? '오늘도 화이팅!',
        body  ?? '할 일 체크하고 가볍게 스타트 🚀',
        fireAt,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('[Reminder] scheduled EXACT @ $fireAt');
    } on PlatformException catch (e) {
      if (_isTypeTokenShrinkerIssue(e)) {
        debugPrint('[Reminder] schedule failed due to shrinker TypeToken issue (ignored): $e');
        return;
      }
      if (e.code == 'exact_alarms_not_permitted') {
        debugPrint('[Reminder] exact failed ($e) -> fallback to INEXACT');
        await _plugin.zonedSchedule(
          _reminderId,
          title ?? '오늘도 화이팅!',
          body  ?? '할 일 체크하고 가볍게 스타트 🚀',
          fireAt,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
        debugPrint('[Reminder] scheduled INEXACT @ $fireAt');
      } else {
        rethrow;
      }
    }
  }
}
