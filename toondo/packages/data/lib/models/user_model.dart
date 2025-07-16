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

  @HiveField(3)
  int points;

  @HiveField(4)
  String? phoneNumber;

  UserModel({
    required this.id,
    required this.loginId,
    this.nickname,
    required this.points,
    this.phoneNumber,
  });

  // Convert model to domain entity
  User toEntity() {
    return User(
      id: id,
      loginId: loginId,
      nickname: nickname,
      points: points,
      phoneNumber: phoneNumber,
    );
  }

  // Create model from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      loginId: user.loginId,
      nickname: user.nickname,
      points: user.points,
      phoneNumber: user.phoneNumber,
    );
  }

  // Create model from JSON (server response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as int,
      loginId: json['loginId'] as String,
      nickname: json['nickname'] as String?,
      points: json['points'] as int,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  // Convert model to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'loginId': loginId,
      'nickname': nickname,
      'points': points,
      'phoneNumber': phoneNumber,
    };
  }

  // get user nickname
  String getNickname() {
    return nickname ?? 'Anonymous';
  }

  void setNickname(String newNickName) {
    nickname = newNickName;
  }

  void setPoints(int newPoint) {
    points += newPoint;
  }
}
