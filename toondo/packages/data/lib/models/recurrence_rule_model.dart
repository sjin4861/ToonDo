import 'package:hive/hive.dart';
import 'package:domain/entities/recurrence_rule.dart';

part 'recurrence_rule_model.g.dart';

@HiveType(typeId: 5)
enum RecurrenceFrequencyModel {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
}

@HiveType(typeId: 6)
enum RecurrenceEndKind {
  @HiveField(0)
  never,
  @HiveField(1)
  onDate,
  @HiveField(2)
  afterCount,
}

@HiveType(typeId: 7)
class RecurrenceEndModel {
  @HiveField(0)
  final RecurrenceEndKind kind;

  @HiveField(1)
  final DateTime? date;

  @HiveField(2)
  final int? count;

  RecurrenceEndModel({required this.kind, this.date, this.count});

  factory RecurrenceEndModel.fromEntity(RecurrenceEnd end) {
    return switch (end) {
      EndNever() => RecurrenceEndModel(kind: RecurrenceEndKind.never),
      EndOnDate(date: final d) =>
        RecurrenceEndModel(kind: RecurrenceEndKind.onDate, date: d),
      EndAfterCount(count: final c) =>
        RecurrenceEndModel(kind: RecurrenceEndKind.afterCount, count: c),
    };
  }

  RecurrenceEnd toEntity() {
    switch (kind) {
      case RecurrenceEndKind.never:
        return const EndNever();
      case RecurrenceEndKind.onDate:
        return EndOnDate(date!);
      case RecurrenceEndKind.afterCount:
        return EndAfterCount(count!);
    }
  }
}

@HiveType(typeId: 8)
class RecurrenceRuleModel {
  @HiveField(0)
  final RecurrenceFrequencyModel frequency;

  @HiveField(1)
  final int interval;

  @HiveField(2)
  final List<int> byWeekdays;

  @HiveField(3)
  final int? byMonthDay;

  @HiveField(4)
  final RecurrenceEndModel end;

  RecurrenceRuleModel({
    required this.frequency,
    this.interval = 1,
    this.byWeekdays = const [],
    this.byMonthDay,
    required this.end,
  });

  factory RecurrenceRuleModel.fromEntity(RecurrenceRule rule) {
    return RecurrenceRuleModel(
      frequency: switch (rule.frequency) {
        RecurrenceFrequency.daily => RecurrenceFrequencyModel.daily,
        RecurrenceFrequency.weekly => RecurrenceFrequencyModel.weekly,
        RecurrenceFrequency.monthly => RecurrenceFrequencyModel.monthly,
        RecurrenceFrequency.yearly => RecurrenceFrequencyModel.yearly,
      },
      interval: rule.interval,
      byWeekdays: List<int>.from(rule.byWeekdays),
      byMonthDay: rule.byMonthDay,
      end: RecurrenceEndModel.fromEntity(rule.end),
    );
  }

  RecurrenceRule toEntity() {
    return RecurrenceRule(
      frequency: switch (frequency) {
        RecurrenceFrequencyModel.daily => RecurrenceFrequency.daily,
        RecurrenceFrequencyModel.weekly => RecurrenceFrequency.weekly,
        RecurrenceFrequencyModel.monthly => RecurrenceFrequency.monthly,
        RecurrenceFrequencyModel.yearly => RecurrenceFrequency.yearly,
      },
      interval: interval,
      byWeekdays: List<int>.from(byWeekdays),
      byMonthDay: byMonthDay,
      end: end.toEntity(),
    );
  }
}
