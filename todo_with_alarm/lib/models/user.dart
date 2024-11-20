// models/user.dart

class User {
  String id;
  String phoneNumber;
  String password;
  String? username; // 닉네임 추가

  User({
    required this.id,
    required this.phoneNumber,
    required this.password,
    this.username,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'password': password,
      'username': username,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      username: json['username'],
    );
  }
}