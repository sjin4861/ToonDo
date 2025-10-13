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
    // ① 현재 글로벌 알림 시간 ('오전 08:00' 또는 '08:00' 둘 다 처리)
    final globalTime = GetIt.instance<AppNotificationViewModel>().settings.time;
    _applyFromStored(globalTime);
  }

  // UI 표시는 기존처럼
  String get selectedTimeLabel => '$_ampm $_hour:$_minute';

  String get ampm => _ampm;
  String get hour => _hour;
  String get minute => _minute;

  void setAmPm(String value) { _ampm = value; notifyListeners(); }
  void setHour(String value) { _hour = value.padLeft(2, '0'); notifyListeners(); }
  void setMinute(String value) { _minute = value.padLeft(2, '0'); notifyListeners(); }

  // ② 저장은 24시간 'HH:mm'으로 고정
  String get _selectedTime24 {
    final h = int.tryParse(_hour) ?? 0;
    final isPm = _ampm == '오후';
    int hh24;
    if (isPm) {
      hh24 = (h % 12) + 12; // 1~11pm -> 13~23, 12pm -> 12
    } else {
      hh24 = (h % 12);      // 12am -> 0
    }
    return '${hh24.toString().padLeft(2, '0')}:${_minute}';
  }

  Future<void> saveSelectedTime() async {
    final time24 = _selectedTime24;                 // <- 저장은 항상 'HH:mm'
    await setReminderTimeUseCase(time24);

    final global = GetIt.instance<AppNotificationViewModel>();
    final current = global.settings;
    await global.update(current.copyWith(time: time24)); // VM이 sync()까지 해줌
  }

  // 저장된 문자열을 내부 UI 상태로 반영
  void _applyFromStored(String stored) {
    // '오전 08:00' 형태
    final ampmMatch = RegExp(r'^(오전|오후)\s+(\d{1,2}):(\d{2})$').firstMatch(stored);
    if (ampmMatch != null) {
      _ampm = ampmMatch.group(1)!;
      _hour = ampmMatch.group(2)!.padLeft(2, '0');
      _minute = ampmMatch.group(3)!.padLeft(2, '0');
      return;
    }
    // 'HH:mm' 24시간 형태
    final hhmm = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(stored);
    if (hhmm != null) {
      final h = int.parse(hhmm.group(1)!);
      _minute = hhmm.group(2)!.padLeft(2, '0');
      if (h == 0) { // 00 -> 12am
        _ampm = '오전'; _hour = '12';
      } else if (h < 12) { // 1~11 -> 오전
        _ampm = '오전'; _hour = h.toString().padLeft(2, '0');
      } else if (h == 12) { // 12 -> 오후 12
        _ampm = '오후'; _hour = '12';
      } else { // 13~23 -> 오후 1~11
        _ampm = '오후'; _hour = (h - 12).toString().padLeft(2, '0');
      }
      return;
    }
  }
}
