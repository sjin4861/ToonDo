import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:domain/repositories/notification_repository.dart';
import 'package:domain/entities/notification_settings.dart';

@LazySingleton(as: NotificationSettingRepository)
class NotificationSettingRepositoryImpl implements NotificationSettingRepository {
  final SharedPreferences prefs;

  NotificationSettingRepositoryImpl(this.prefs);

  static const _sound = 'notification_sound';
  static const _all = 'notification_all';
  static const _report = 'notification_report';
  static const _reminder = 'notification_reminder';
  static const _time = 'notification_time';

  @override
  Future<NotificationSettings> getSettings() async {
    return NotificationSettings(
      sound: prefs.getBool(_sound) ?? true,
      all: prefs.getBool(_all) ?? false,
      report: prefs.getBool(_report) ?? false,
      reminder: prefs.getBool(_reminder) ?? false,
      time: prefs.getString(_time) ?? '09:00',
    );
  }

  @override
  Future<void> setSettings(NotificationSettings settings) async {
    await prefs.setBool(_sound, settings.sound);
    await prefs.setBool(_all, settings.all);
    await prefs.setBool(_report, settings.report);
    await prefs.setBool(_reminder, settings.reminder);
    await prefs.setString(_time, settings.time);
  }

  @override
  Future<void> setReminderTime(String time) async {
    await prefs.setString(_time, time);
  }
}
