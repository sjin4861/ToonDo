/// 슬라임 애니메이션 상태 열거형
///
/// 슬라임 캐릭터의 다양한 애니메이션 상태를 표현하는 값 객체입니다.
class SlimeAnimationState {
  /// 애니메이션 상태 값 (문자열)
  final String value;
  
  /// 애니메이션 상태 설명
  final String description;
  
  /// 기본 생성자 - private로 선언하여 인스턴스 통제
  const SlimeAnimationState._(this.value, this.description);
  
  /// 대기 (기본) 상태
  static const idle = SlimeAnimationState._('idle', '대기 상태');
  
  /// 눈 깜빡임
  static const blink = SlimeAnimationState._('blink', '눈 깜빡임');
  
  /// 행복한 표정
  static const happy = SlimeAnimationState._('happy', '행복한 표정');
  
  /// 좌우로 흔들림
  static const wiggle = SlimeAnimationState._('wiggle', '좌우로 흔들림');
  
  /// 상하로 흔들림
  static const bounce = SlimeAnimationState._('bounce', '상하로 흔들림');
  
  /// 점프
  static const jump = SlimeAnimationState._('jump', '점프');
  
  /// 회전
  static const rotate = SlimeAnimationState._('rotate', '회전');
  
  /// 눌러 납작해짐
  static const squish = SlimeAnimationState._('squish', '눌러 납작해짐');
  
  /// 늘어남
  static const stretch = SlimeAnimationState._('stretch', '늘어남');
  
  /// 수축
  static const shrink = SlimeAnimationState._('shrink', '수축');
  
  /// 확장
  static const expand = SlimeAnimationState._('expand', '확장');
  
  /// 잠들기
  static const sleep = SlimeAnimationState._('sleep', '잠들기');
  
  /// 색상 변화
  static const colorChange = SlimeAnimationState._('color_change', '색상 변화');
  
  /// 분열
  static const split = SlimeAnimationState._('split', '분열');
  
  /// 반짝임
  static const shine = SlimeAnimationState._('shine', '반짝임');
  
  /// 녹음
  static const melt = SlimeAnimationState._('melt', '녹음');
  
  /// 모든 가능한 애니메이션 상태 목록
  static const values = [
    idle,
    blink,
    happy,
    wiggle,
    bounce,
    jump,
    rotate,
    squish,
    stretch,
    shrink,
    expand,
    sleep,
    colorChange,
    split,
    shine,
    melt,
  ];
  
  /// 문자열에서 애니메이션 상태 생성
  static SlimeAnimationState fromString(String value) {
    // 'id'는 레거시 코드에서 'idle'로 사용되는 경우가 있음
    if (value == 'id') return idle;
    // 'eye'는 레거시 코드에서 'blink'로 사용되는 경우가 있음
    if (value == 'eye') return blink;
    
    return values.firstWhere(
      (state) => state.value == value,
      orElse: () => idle,
    );
  }
  
  @override
  String toString() => value;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SlimeAnimationState && other.value == value;
  }
  
  @override
  int get hashCode => value.hashCode;
}