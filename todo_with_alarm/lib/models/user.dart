// models/user.dart

class User {
  int id;
  String phoneNumber;
  String? username; // 닉네임 추가

  User({
    required this.id,
    required this.phoneNumber,
    this.username,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'username': username,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      username: json['username'],
    );
  }

  //user nickname 업데이트 메서드
  void updateUsername(String nickname) {
    username = nickname;
  }
}