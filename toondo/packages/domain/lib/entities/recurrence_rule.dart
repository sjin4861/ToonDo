enum RecurrenceFrequency { daily, weekly, monthly, yearly }

sealed class RecurrenceEnd {
  const RecurrenceEnd();
}

class EndNever extends RecurrenceEnd {
  const EndNever();

  @override
  bool operator ==(Object other) => other is EndNever;

  @override
  int get hashCode => 0;
}

class EndOnDate extends RecurrenceEnd {
  final DateTime date;
  const EndOnDate(this.date);

  @override
  bool operator ==(Object other) =>
      other is EndOnDate && other.date == date;

  @override
  int get hashCode => date.hashCode;
}

class EndAfterCount extends RecurrenceEnd {
  final int count;
  const EndAfterCount(this.count);

  @override
  bool operator ==(Object other) =>
      other is EndAfterCount && other.count == count;

  @override
  int get hashCode => count.hashCode;
}

class RecurrenceRule {
  final RecurrenceFrequency frequency;
  final int interval;
  final List<int> byWeekdays;
  final int? byMonthDay;
  final RecurrenceEnd end;

  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.byWeekdays = const [],
    this.byMonthDay,
    this.end = const EndNever(),
  });

  RecurrenceRule copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    List<int>? byWeekdays,
    int? byMonthDay,
    RecurrenceEnd? end,
  }) {
    return RecurrenceRule(
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      byWeekdays: byWeekdays ?? this.byWeekdays,
      byMonthDay: byMonthDay ?? this.byMonthDay,
      end: end ?? this.end,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! RecurrenceRule) return false;
    if (other.frequency != frequency) return false;
    if (other.interval != interval) return false;
    if (other.byMonthDay != byMonthDay) return false;
    if (other.end != end) return false;
    if (other.byWeekdays.length != byWeekdays.length) return false;
    for (var i = 0; i < byWeekdays.length; i++) {
      if (other.byWeekdays[i] != byWeekdays[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        frequency,
        interval,
        byMonthDay,
        end,
        Object.hashAll(byWeekdays),
      );
}
