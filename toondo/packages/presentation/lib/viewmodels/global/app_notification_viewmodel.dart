import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/entities/notification_settings.dart';
import 'package:domain/usecases/notification/get_notification_settings.dart';
import 'package:domain/usecases/notification/set_notification_settings.dart';

@lazySingleton
class AppNotificationViewModel extends ChangeNotifier {
  final GetNotificationSettingsUseCase _get;
  final SetNotificationSettingsUseCase _set;

  NotificationSettings _settings = const NotificationSettings(
    sound: true,
    all: true,
    report: true,
    reminder: true,
    time: '03:00',
  );

  NotificationSettings get settings => _settings;

  AppNotificationViewModel(this._get, this._set);

  Future<void> load() async {
    _settings = await _get();
    notifyListeners();
  }

  Future<void> update(NotificationSettings newSettings) async {
    _settings = newSettings;
    await _set(newSettings);
    notifyListeners();
  }
}