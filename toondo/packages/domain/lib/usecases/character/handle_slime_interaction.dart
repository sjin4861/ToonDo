import 'package:domain/repositories/slime_character_repository.dart';
import 'package:injectable/injectable.dart';

/// 슬라임 캐릭터와의 상호작용을 처리하는 UseCase
@injectable
class HandleSlimeInteractionUseCase {
  final SlimeCharacterRepository _repository;

  HandleSlimeInteractionUseCase(this._repository);

  /// 탭 상호작용 처리
  Future<String> handleTap() async {
    final availableAnims = await _repository.getAvailableAnimations();
    final basicAnims = availableAnims.where((anim) => 
      ['eye', 'angry', 'happy', 'shine', 'melt'].contains(anim)
    ).toList();
    
    if (basicAnims.isEmpty) return 'id';
    
    // 랜덤 애니메이션 선택
    basicAnims.shuffle();
    final selectedAnim = basicAnims.first;
    
    await _repository.updateAnimationState(selectedAnim);
    return selectedAnim;
  }

  /// 길게 누르기(long press) 상호작용 처리
  Future<String> handleLongPress() async {
    final slimeState = await _repository.getSlimeStateBasedOnGoals();
    String animation = 'shine';
    
    if (slimeState == 'excellent') {
      final isUnlocked = await _repository.isSpecialAnimationUnlocked('dance');
      if (isUnlocked) {
        animation = 'dance';
      }
    }
    
    await _repository.updateAnimationState(animation);
    return animation;
  }
  
  /// 드래그 상호작용 처리
  Future<String> handleDrag() async {
    final isUnlocked = await _repository.isSpecialAnimationUnlocked('bounce');
    final animation = isUnlocked ? 'bounce' : 'melt';
    
    await _repository.updateAnimationState(animation);
    return animation;
  }
  
  /// 꼬집기(pinch) 상호작용 처리
  Future<String> handlePinch() async {
    const animation = 'angry';
    await _repository.updateAnimationState(animation);
    return animation;
  }
  
  /// 이중 탭(double tap) 처리
  Future<String> handleDoubleTap() async {
    final isSpecialUnlocked = await _repository.isSpecialAnimationUnlocked('special');
    final animation = isSpecialUnlocked ? 'special' : 'happy';
    
    await _repository.updateAnimationState(animation);
    return animation;
  }
}