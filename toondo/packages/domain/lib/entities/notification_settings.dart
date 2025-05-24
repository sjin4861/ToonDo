import 'package:flutter/foundation.dart';

@immutable
class NotificationSettings {
  final bool sound;
  final bool all;
  final bool report;
  final bool reminder;
  final String time;

  const NotificationSettings({
    required this.sound,
    required this.all,
    required this.report,
    required this.reminder,
    required this.time,
  });

  NotificationSettings copyWith({
    bool? sound,
    bool? all,
    bool? report,
    bool? reminder,
    String? time,
  }) {
    return NotificationSettings(
      sound: sound ?? this.sound,
      all: all ?? this.all,
      report: report ?? this.report,
      reminder: reminder ?? this.reminder,
      time: time ?? this.time,
    );
  }
}
