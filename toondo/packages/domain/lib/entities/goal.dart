import 'package:domain/entities/status.dart';

class Goal {
  final String id;
  final String name;
  final String? icon;
  final double progress;
  final DateTime startDate;
  // TODO: '마감일 없이 할래요' 기능 구현 - endDate를 optional로 변경하고 null 처리 로직 추가
  final DateTime? endDate; // 마감일 없는 목표를 위해 nullable로 변경 필요
  final bool showOnHome; // 메인화면 노출 여부
  Status status;

  Goal({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    // TODO: '마감일 없이 할래요' 기능 - endDate를 optional로 변경
    this.endDate, // required 제거하여 마감일 없는 목표 지원
    this.showOnHome = false,
    this.status = Status.active,
  });

  Goal copyWith({
    String? id,
    String? name,
    String? icon,
    double? progress,
    DateTime? startDate,
    // TODO: '마감일 없이 할래요' 기능 - copyWith에서도 endDate nullable 처리
    DateTime? endDate, // nullable로 변경
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
    // TODO: '마감일 없이 할래요' 기능 - empty Goal도 endDate nullable 처리
    endDate: DateTime.now(), // 기본값 유지, 추후 null 허용 고려
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
      // TODO: '마감일 없이 할래요' 기능 - endDate null 안전 처리
      (endDate?.hashCode ?? 0) ^ // nullable endDate 처리
      showOnHome.hashCode ^
      status.hashCode;
}
