import 'package:hive/hive.dart';

part 'user.g.dart'; // 어댑터 생성을 위한 부분 파일

@HiveType(typeId: 3) // typeId는 앱 내에서 고유해야 합니다.
class User {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String phoneNumber;
  
  @HiveField(2)
  String? username; // 닉네임

  User({
    required this.id,
    required this.phoneNumber,
    this.username,
  });

  // JSON 변환 메서드 (서버와의 통신에 사용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'username': username,
    };
  }

  // JSON으로부터 User 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'], // 서버 응답 key에 맞춰 변경하세요.
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['nickname'],
    );
  }

  void updateUsername(String newUsername) {
    username = newUsername;
  }
}