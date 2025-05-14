class User {
  final int id;
  final String loginId;
  final String? nickname;
  final int points;
  final DateTime createdAt;

  const User._internal({
    required this.id,
    required this.loginId,
    this.nickname,
    required this.points,
    required this.createdAt,
  });

  factory User({
    required int id,
    required String loginId,
    String? nickname,
    required int points,
    DateTime? createdAt,
  }) {
    return User._internal(
      id: id,
      loginId: loginId,
      nickname: nickname,
      points: points,
      createdAt: createdAt ?? DateTime.now(), // 기본값 처리
    );
  }
}
