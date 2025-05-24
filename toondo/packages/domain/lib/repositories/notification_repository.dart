import 'package:domain/entities/notification_settings.dart';

abstract class NotificationSettingRepository {
  Future<NotificationSettings> getSettings();
  Future<void> setSettings(NotificationSettings settings);
  Future<void> setReminderTime(String time);
}