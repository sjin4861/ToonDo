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

  @override
  String toString() {
    return 'User(id: $id, loginId: $loginId, nickname: $nickname, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.loginId == loginId &&
        other.nickname == nickname &&
        other.points == points;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      loginId.hashCode ^
      (nickname?.hashCode ?? 0) ^
      points.hashCode;
}
