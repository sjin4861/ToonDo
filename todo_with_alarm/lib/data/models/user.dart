import 'package:hive/hive.dart';

part 'user.g.dart'; // 어댑터 생성을 위한 부분 파일

@HiveType(typeId: 3) // typeId는 앱 내에서 고유해야 합니다.
class User extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String phoneNumber;
  
  @HiveField(2)
  String? username; // 닉네임

  @HiveField(3)
  DateTime? lastTodoSyncTime;   // Todo 동기화 시각

  @HiveField(4)
  DateTime? lastGoalSyncTime;   // Goal 동기화 시각

  @HiveField(5)
  List<String>? conversationLog; // 대화 이력 예시 (문자열 리스트)

  User({
    required this.id,
    required this.phoneNumber,
    this.username,
    this.lastTodoSyncTime,
    this.lastGoalSyncTime,
    this.conversationLog,
  });

  // JSON 변환 메서드 (서버와의 통신에 사용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'username': username,
      'lastTodoSyncTime': lastTodoSyncTime?.toIso8601String(),
      'lastGoalSyncTime': lastGoalSyncTime?.toIso8601String(),
      'conversationLog': conversationLog,
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

  // 한글이 깨지지 않도록 단순 문자열 업데이트
  void updateUsername(String newUsername) {
    username = newUsername;
  }

  bool updateTodoSyncTime(DateTime syncTime) {
    if (lastTodoSyncTime != syncTime) {
      lastTodoSyncTime = syncTime;
      return true;
    }
    return false;
  }

  bool updateGoalSyncTime(DateTime syncTime) {
    if (lastGoalSyncTime != syncTime) {
      lastGoalSyncTime = syncTime;
      return true;
    }
    return false;
  }

  void addConversationLog(String log) {
    conversationLog ??= [];
    conversationLog!.add(log);
  }

  void clearConversationLog() {
    conversationLog = [];
  }

  @override
  String toString() {
    return 'User{id: $id, phoneNumber: $phoneNumber, username: $username}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.phoneNumber == phoneNumber &&
      other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^ phoneNumber.hashCode ^ username.hashCode;
  }
}