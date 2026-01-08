import 'package:data/utils/goal_status_mapper.dart';
import 'package:hive/hive.dart';
import 'package:domain/entities/goal.dart';
import 'package:data/models/goal_status_enum.dart';
part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? icon;

  @HiveField(3)
  double progress;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  // TODO: '마감일 없이 할래요' 기능 - GoalModel의 endDate를 nullable로 변경
  DateTime? endDate; // nullable로 변경하여 마감일 없는 목표 지원

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  GoalStatusEnum status; // stores the index of GoalStatus

  @HiveField(8)
  bool isSynced;

  @HiveField(9, defaultValue: false)
  bool showOnHome; // 메인화면 노출 여부

  GoalModel({
    required this.id,
    required this.name,
    this.icon,
    this.progress = 0.0,
    required this.startDate,
    // TODO: '마감일 없이 할래요' 기능 - GoalModel 생성자에서 endDate optional 처리
    this.endDate, // required 제거
    this.isCompleted = false,
    this.status = GoalStatusEnum.active,
    this.isSynced = false,
    this.showOnHome = false,
  });

  // Entity → Model conversion
  factory GoalModel.fromEntity(Goal entity) {
    return GoalModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      progress: entity.progress,
      startDate: entity.startDate,
      endDate: entity.endDate,
      status: GoalStatusMapper.fromDomain(entity.status),
      showOnHome: entity.showOnHome,
      isSynced: false,
    );
  }

  // Model → Entity conversion
  Goal toEntity() {
    return Goal(
      id: id,
      name: name,
      icon: icon,
      progress: progress,
      startDate: startDate,
      endDate: endDate,
      showOnHome: showOnHome,
      status: GoalStatusMapper.toDomain(status),
    );
  }

  Map<String, dynamic> toJson() {
    // '마감일 없이 할래요' 기능 - endDate가 null인 경우 2099-12-31로 변환하여 전송
    final endDateToSend = endDate ?? DateTime(2099, 12, 31);
    
    return {
      'goalId': id,
      'goalName': name,
      'icon': icon,
      'progress': progress,
      'startDate': startDate.toIso8601String().split('T')[0], // yyyy-MM-dd 형식으로 변환
      'endDate': endDateToSend.toIso8601String().split('T')[0], // null인 경우 2099-12-31 전송
      'status': status.index,  // 열거형의 인덱스 전송
      'showOnHome': showOnHome,
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['icon'] as String?;
    String? normalizedIcon;
    if (rawIcon != null) {
      // 커스텀 아이콘 경로 (파일 시스템 경로)는 그대로 유지
      if (rawIcon.startsWith('/')) {
        normalizedIcon = rawIcon;
      } else if (rawIcon.startsWith('assets/')) {
        normalizedIcon = rawIcon;
      } else {
        // 일반 아이콘 이름만 있는 경우 asset 경로로 변환
        final fileName = rawIcon.startsWith('ic_') ? rawIcon : 'ic_$rawIcon';
        normalizedIcon = 'assets/icons/$fileName';
      }
    }
    
    // '마감일 없이 할래요' 기능 - 서버에서 2099-12-31이 오면 null로 변환
    DateTime? parsedEndDate;
    final endDateString = json['endDate'] as String?;
    if (endDateString != null) {
      final endDate = DateTime.parse(endDateString);
      // 2099년 이후 날짜는 마감일 없음으로 간주
      parsedEndDate = endDate.year >= 2099 ? null : endDate;
    }
    
    return GoalModel(
      id: json['goalId'].toString(), // 변경: 'id' 대신 'goalId'
      name: json['goalName'],        // 변경: 'name' 대신 'goalName'
      icon: normalizedIcon,
      progress: (json['progress'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: parsedEndDate, // 2099년 이후면 null로 처리
      isCompleted: false,            // API에서 isCompleted 미전달 시 기본값 사용
      status: json['status'] != null
          ? GoalStatusEnum.values[json['status']]
          : GoalStatusEnum.active,       // null인 경우 기본값 처리
      showOnHome: json['showOnHome'] ?? false, // 기본값 false
      isSynced: true,
    );
  }

  double getExpectedProgress() {
    // TODO: '마감일 없이 할래요' 기능 - endDate가 null인 경우 예상 진행률 계산 로직 수정
    if (endDate == null) {
      // 마감일이 없는 목표는 시간 기반 진행률을 계산할 수 없음
      return 0.0; // 또는 다른 계산 방식 적용
    }
    final totalDuration = endDate!.difference(startDate).inSeconds;
    final elapsedDuration = DateTime.now().difference(startDate).inSeconds;
    if (totalDuration <= 0) return 0.0;
    final double expectedProgress = (elapsedDuration / totalDuration) * 100;
    return expectedProgress.clamp(0.0, 100.0);
  }

  void markAsCompleted() {
    isCompleted = true;
    progress = 100.0;
  }

  void updateDuration(DateTime newStartDate, DateTime newEndDate) {
    startDate = newStartDate;
    endDate = newEndDate;
  }

  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  Duration getRemainingDuration() {
    // TODO: '마감일 없이 할래요' 기능 - endDate가 null인 경우 남은 기간 계산 로직 수정
    if (endDate == null) {
      // 마감일이 없는 목표는 남은 기간이 무한대 또는 0
      return Duration.zero; // 또는 Duration(days: 365 * 100) 등
    }
    return endDate!.difference(DateTime.now());
  }

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, icon: $icon, progress: $progress, startDate: $startDate, endDate: $endDate)';
  }
}
