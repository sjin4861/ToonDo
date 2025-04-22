import 'package:domain/repositories/slime_character_repository.dart';
import 'package:injectable/injectable.dart';

/// 목표 달성에 따라 슬라임 캐릭터의 특별 애니메이션을 잠금 해제하는 UseCase
@injectable
class UnlockSpecialAnimationUseCase {
  final SlimeCharacterRepository _repository;

  UnlockSpecialAnimationUseCase(this._repository);

  /// 목표 달성에 따라 특별 애니메이션을 잠금 해제합니다.
  /// [goalCount] 완료한 목표의 수
  /// [goalType] 목표의 종류 (ex: 'daily', 'weekly', 'monthly')
  Future<String?> call(int goalCount, String goalType) async {
    String? unlockedAnimation;
    
    // 특별 애니메이션 잠금 해제 조건
    if (goalType == 'daily' && goalCount >= 5) {
      unlockedAnimation = 'bounce';
    } else if (goalType == 'weekly' && goalCount >= 3) {
      unlockedAnimation = 'dance';
    } else if (goalType == 'monthly' && goalCount >= 1) {
      unlockedAnimation = 'special';
    }
    
    if (unlockedAnimation != null) {
      // 이미 잠금 해제된 애니메이션인지 확인
      final isUnlocked = await _repository.isSpecialAnimationUnlocked(unlockedAnimation);
      if (!isUnlocked) {
        await _repository.unlockSpecialAnimation(unlockedAnimation);
        return unlockedAnimation;
      }
    }
    
    return null; // 잠금 해제된 애니메이션이 없으면 null 반환
  }
}