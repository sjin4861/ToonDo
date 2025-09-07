import 'package:domain/entities/status.dart';

class Goal {
  final String id;
  final String name;
  final String? icon;
  final double progress;
  final DateTime startDate;
  final DateTime endDate;
  final bool showOnHome; // 메인화면 노출 여부
  Status status;

  Goal({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    required this.endDate,
    this.showOnHome = false,
    this.status = Status.active,
  });

  Goal copyWith({
    String? id,
    String? name,
    String? icon,
    double? progress,
    DateTime? startDate,
    DateTime? endDate,
    bool? showOnHome,
    Status? status,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showOnHome: showOnHome ?? this.showOnHome,
      status: status ?? this.status,
    );
  }

  factory Goal.empty() => Goal(
    id: '-1',
    name: '목표 미설정',
    icon: 'assets/icons/ic_help-circle.svg',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
  );

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
          showOnHome == other.showOnHome &&
          status == other.status;

  @override
  int get hashCode =>
      // id is ignored in hashCode to maintain consistency with equality
      name.hashCode ^
      (icon?.hashCode ?? 0) ^
      progress.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      showOnHome.hashCode ^
      status.hashCode;
}
