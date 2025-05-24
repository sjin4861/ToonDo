class User {
  final int id;
  final String loginId;
  final String? nickname;
  final String? phoneNumber; // NOTE 현재 서버측 수정이 안되어서 nullable 인데 추후수정
  final int points;
  final DateTime createdAt;

  const User._internal({
    required this.id,
    required this.loginId,
    this.nickname,
    this.phoneNumber,
    required this.points,
    required this.createdAt,
  });

  factory User({
    required int id,
    required String loginId,
    String? nickname,
    required int points,
    DateTime? createdAt,
    String? phoneNumber,
  }) {
    return User._internal(
      id: id,
      loginId: loginId,
      nickname: nickname,
      points: points,
      createdAt: createdAt ?? DateTime.now(), // 기본값 처리
      phoneNumber: phoneNumber,
    );
  }
}
