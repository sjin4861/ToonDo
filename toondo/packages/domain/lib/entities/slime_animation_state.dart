/// 슬라임 애니메이션 상태 값 객체 ― “필요한 것만” 유지 버전
class SlimeAnimationState {
  final String value;          // Rive 애니메이션 키
  final String description;    // 한국어 설명

  const SlimeAnimationState._(this.value, this.description);

  /* ───────── 실제 .riv 기준 ───────── */

  static const idle  = SlimeAnimationState._('id',    '대기 상태');
  static const blink = SlimeAnimationState._('s',     '눈 깜빡임');
  static const happy = SlimeAnimationState._('happy', '행복한 표정');
  static const angry = SlimeAnimationState._('angry', '화남');
  static const jump  = SlimeAnimationState._('jump',  '점프');
  static const melt  = SlimeAnimationState._('melt',  '녹음');
  static const shine = SlimeAnimationState._('shine', '반짝임');

  /// 현재 앱에서 쓰는 *모든* 상태 목록
  static const values = [
    idle, blink, happy, angry, jump, melt, shine,
  ];

  /// 문자열 → 상태 변환
  static SlimeAnimationState fromString(String value) =>
      values.firstWhere(
        (state) => state.value == value,
        orElse: () => idle,        // 존재하지 않는 키는 idle 로 대체
      );

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlimeAnimationState && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
