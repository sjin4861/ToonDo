import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/notification_settings.dart';
import 'package:domain/usecases/notification/get_notification_settings.dart';
import 'package:domain/usecases/notification/set_notification_settings.dart';
import 'package:common/notification/reminder_notification_service.dart';
import 'package:flutter/services.dart';

@lazySingleton
class AppNotificationViewModel extends ChangeNotifier {
  final GetNotificationSettingsUseCase _get;
  final SetNotificationSettingsUseCase _set;
  final ReminderNotificationService _reminder;

  AppNotificationViewModel(this._get, this._set, [ReminderNotificationService? reminder])
      : _reminder = reminder ?? GetIt.I<ReminderNotificationService>();

  NotificationSettings _settings = const NotificationSettings(
    sound: true,
    all: false,
    report: false,
    reminder: false,
    time: '03:00',
  );

  NotificationSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _get();
    notifyListeners();

    // 앱 시작 시 현재 설정으로 스케줄 동기화
    try {
      await _reminder.sync(
        enabledAll: _settings.all,
        enabledReminder: _settings.reminder,
        soundOn: _settings.sound,
        timeHHmm: _settings.time,
      );
    } on PlatformException catch (e) {
      // 알림 동기화 실패가 앱 부팅을 막지 않도록 best-effort로 무시
      debugPrint('[Notification] sync failed (ignored): $e');
    }
  }

  Future<void> update(NotificationSettings newSettings) async {
    _settings = newSettings;
    await _set(newSettings);
    notifyListeners();

    // 설정 변경될 때마다 즉시 재스케줄
    try {
      await _reminder.sync(
        enabledAll: _settings.all,
        enabledReminder: _settings.reminder,
        soundOn: _settings.sound,
        timeHHmm: _settings.time,
      );
    } on PlatformException catch (e) {
      debugPrint('[Notification] sync failed (ignored): $e');
    }
  }
}