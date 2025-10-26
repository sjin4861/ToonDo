import 'package:domain/entities/user.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String loginId;

  @HiveField(2)
  String? nickname;

  // 가입 일시 (서버 ISO8601 문자열 기반)
  @HiveField(3)
  DateTime? createdAt;

  UserModel({
    required this.id,
    required this.loginId,
    this.nickname,
    this.createdAt,
  });

  // Convert model to domain entity
  User toEntity() {
    return User(
      id: id,
      loginId: loginId,
      nickname: nickname,
      createdAt: createdAt, // null이면 도메인에서 기본값(DateTime.now()) 처리
    );
  }

  // Create model from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      loginId: user.loginId,
      nickname: user.nickname,
      createdAt: user.createdAt,
    );
  }

  // Create model from JSON (server response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 서버 응답 구조가 평평(flat)하다는 가정 하에 createdAt 파싱, 없으면 null 허용
    final String? createdAtStr = json['createdAt'] as String?;
    final DateTime? parsedCreatedAt = createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;
    return UserModel(
      id: json['userId'] as int,
      loginId: json['loginId'] as String,
      nickname: json['nickname'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  // Convert model to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'loginId': loginId,
      'nickname': nickname,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  // get user nickname
  String getNickname() {
    return nickname ?? 'Anonymous';
  }

  void setNickname(String newNickName) {
    nickname = newNickName;
  }
}
