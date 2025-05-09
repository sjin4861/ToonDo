import 'package:domain/entities/status.dart';

class Goal {
  final String id;
  final String name;
  final String? icon;
  final double progress;
  final DateTime startDate;
  final DateTime endDate;
  Status status;

  Goal({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.status = Status.active,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          runtimeType == other.runtimeType &&
          // id is ignored for equality to allow Mockito matching
          name == other.name &&
          icon == other.icon &&
          progress == other.progress &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          status == other.status;

  @override
  int get hashCode =>
      // id is ignored in hashCode to maintain consistency with equality
      name.hashCode ^
      (icon?.hashCode ?? 0) ^
      progress.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      status.hashCode;
}
