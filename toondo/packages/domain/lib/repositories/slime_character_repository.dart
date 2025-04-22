import 'package:domain/entities/slime_character.dart';

/// 슬라임 캐릭터에 관련된 데이터 접근을 추상화하는 인터페이스
abstract class SlimeCharacterRepository {
  /// 현재 슬라임 캐릭터 정보 조회
  Future<SlimeCharacter> getSlimeCharacter();
  
  /// 슬라임 캐릭터의 애니메이션 상태 업데이트
  Future<void> updateAnimationState(String animationState);
  
  /// 슬라임 캐릭터와의 대화 기록 추가
  Future<void> addConversation(String message);
  
  /// 슬라임 캐릭터의 소품 목록 업데이트
  Future<void> updateProps(List<String> props);
  
  /// 특별 애니메이션 잠금 해제 여부 확인
  Future<bool> isSpecialAnimationUnlocked(String animationName);
  
  /// 특별 애니메이션 잠금 해제
  Future<void> unlockSpecialAnimation(String animationName);
  
  /// 사용 가능한 애니메이션 목록 가져오기
  Future<List<String>> getAvailableAnimations();
  
  /// 목표 달성 진행도에 따른 슬라임 상태 가져오기
  Future<String> getSlimeStateBasedOnGoals();
}