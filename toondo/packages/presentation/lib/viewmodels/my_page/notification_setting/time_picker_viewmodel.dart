import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TimePickerViewModel extends ChangeNotifier {
  String _ampm = '오전';
  String _hour = '08';
  String _minute = '00';

  String get selectedTime => '$_ampm $_hour:$_minute';

  void setAmPm(String value) {
    _ampm = value;
    notifyListeners();
  }

  void setHour(String value) {
    _hour = value;
    notifyListeners();
  }

  void setMinute(String value) {
    _minute = value;
    notifyListeners();
  }

  void saveSelectedTime() {
    // TODO: 서버 전송 or 로컬 저장 등
    debugPrint('저장된 시간: $selectedTime');
  }
}
