import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/usecases/notification/set_reminder_time.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';


@injectable
class TimePickerViewModel extends ChangeNotifier {
  String _ampm = '오전';
  String _hour = '08';
  String _minute = '00';

  final SetReminderTime setReminderTimeUseCase;

  TimePickerViewModel(this.setReminderTimeUseCase) {
    // 초기화 시 현재 글로벌 알림 시간 가져와 파싱
    final globalTime = GetIt.instance<AppNotificationViewModel>().settings.time;
    final parts = globalTime.split(RegExp(r'[ :]+'));
    if (parts.length == 3) {
      _ampm = parts[0];
      _hour = parts[1];
      _minute = parts[2];
    }
  }

  String get selectedTime => '$_ampm $_hour:$_minute';

  String get ampm => _ampm;
  String get hour => _hour;
  String get minute => _minute;

  void setAmPm(String value) {
    _ampm = value;
    notifyListeners();
  }

  void setHour(String value) {
    _hour = value.padLeft(2, '0');
    notifyListeners();
  }

  void setMinute(String value) {
    _minute = value.padLeft(2, '0');
    notifyListeners();
  }

  Future<void> saveSelectedTime() async {
    final time = selectedTime;
    await setReminderTimeUseCase(time);

    final global = GetIt.instance<AppNotificationViewModel>();
    final current = global.settings;
    global.update(current.copyWith(time: time));
  }
}

