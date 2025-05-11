class SlimeResponse {
  /// GPT 또는 시스템이 돌려준 텍스트(없을 수도 있음)
  final String? message;

  /// Rive 애니메이션 key (필수)
  final String animationKey;

  /// 추가 메타(표정, 음성 등)도 필요하면 확장 가능
  const SlimeResponse({this.message, required this.animationKey});
}
