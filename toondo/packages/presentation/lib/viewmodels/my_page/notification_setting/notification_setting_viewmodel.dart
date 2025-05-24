import 'package:domain/entities/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';

@injectable
class NotificationSettingViewModel extends ChangeNotifier {
  final AppNotificationViewModel _global;
  NotificationSettingViewModel(this._global);

  NotificationSettings get settings => _global.settings;

  void toggleSound() {
    _global.update(settings.copyWith(sound: !settings.sound));
    notifyListeners();
  }

  void toggleAll() {
    _global.update(settings.copyWith(all: !settings.all));
    notifyListeners();
  }

  void toggleReport() {
    _global.update(settings.copyWith(report: !settings.report));
    notifyListeners();
  }

  void toggleReminder() {
    _global.update(settings.copyWith(reminder: !settings.reminder));
    notifyListeners();
  }

  void updateTime(String time) {
    _global.update(settings.copyWith(time: time));
    notifyListeners();
  }
}
