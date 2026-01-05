import 'package:hive/hive.dart';

part 'custom_icon_model.g.dart';

/// 커스텀 아이콘 정보를 저장하는 Hive 모델
/// 로컬 파일 시스템에 저장된 커스텀 아이콘의 경로를 관리합니다
@HiveType(typeId: 4)
class CustomIconModel extends HiveObject {
  @HiveField(0)
  String id; // 고유 ID (UUID)

  @HiveField(1)
  String filePath; // 로컬 파일 경로

  @HiveField(2)
  DateTime createdAt; // 생성 시간

  @HiveField(3)
  DateTime? lastUsedAt; // 마지막 사용 시간 (정렬용)

  CustomIconModel({
    required this.id,
    required this.filePath,
    required this.createdAt,
    this.lastUsedAt,
  });

  /// 파일 경로로부터 모델 생성
  factory CustomIconModel.fromFilePath(String filePath) {
    return CustomIconModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filePath: filePath,
      createdAt: DateTime.now(),
      lastUsedAt: DateTime.now(),
    );
  }

  /// 마지막 사용 시간 업데이트
  void updateLastUsed() {
    lastUsedAt = DateTime.now();
  }

  @override
  String toString() {
    return 'CustomIconModel(id: $id, filePath: $filePath, createdAt: $createdAt, lastUsedAt: $lastUsedAt)';
  }
}

