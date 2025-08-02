class User {
  final int id;
  final String loginId;
  final String? nickname;
  final DateTime createdAt;

  const User._internal({
    required this.id,
    required this.loginId,
    this.nickname,
    required this.createdAt,
  });

  factory User({
    required int id,
    required String loginId,
    String? nickname,
    DateTime? createdAt,
  }) {
    return User._internal(
      id: id,
      loginId: loginId,
      nickname: nickname,
      createdAt: createdAt ?? DateTime.now(), // 기본값 처리
    );
  }
}
