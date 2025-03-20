class User {
  final int id;
  final String loginId;
  final String? nickname;
  final int points; // 향후 화폐로 사용

  const User({
    required this.id,
    required this.loginId,
    this.nickname,
    required this.points,
  });
}
