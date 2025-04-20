import 'package:injectable/injectable.dart';
import 'package:domain/repositories/slime_character_repository.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:data/models/slime_character_model.dart';

@LazySingleton(as: SlimeCharacterRepository)
class SlimeCharacterRepositoryImpl implements SlimeCharacterRepository {
  SlimeCharacterModel? _cachedCharacter;

  @override
  Future<SlimeCharacter> getSlimeCharacter() async {
    // 캐시된 슬라임 캐릭터가 없으면 기본 캐릭터 생성
    _cachedCharacter ??= SlimeCharacterModel(
      name: '슬라임',
      conversationHistory: [],
      rolePrompt: '너는 귀여운 슬라임이야.',
      props: [],
      animationState: 'idle',
    );
    return _cachedCharacter!.toEntity();
  }

  @override
  Future<void> updateAnimationState(String animationState) async {
    if (_cachedCharacter == null) {
      await getSlimeCharacter();
    }
    _cachedCharacter = SlimeCharacterModel(
      name: _cachedCharacter!.name,
      conversationHistory: _cachedCharacter!.conversationHistory,
      rolePrompt: _cachedCharacter!.rolePrompt,
      props: _cachedCharacter!.props,
      animationState: animationState,
    );
    // TODO: 지속적 저장소에 저장하는 코드 추가
  }

  @override
  Future<void> addConversation(String message) async {
    if (_cachedCharacter == null) {
      await getSlimeCharacter();
    }
    final updatedHistory = List<String>.from(_cachedCharacter!.conversationHistory)
      ..add(message);
    
    _cachedCharacter = SlimeCharacterModel(
      name: _cachedCharacter!.name,
      conversationHistory: updatedHistory,
      rolePrompt: _cachedCharacter!.rolePrompt,
      props: _cachedCharacter!.props,
      animationState: _cachedCharacter!.animationState,
    );
    // TODO: 지속적 저장소에 저장하는 코드 추가
  }

  @override
  Future<void> updateProps(List<String> props) async {
    if (_cachedCharacter == null) {
      await getSlimeCharacter();
    }
    _cachedCharacter = SlimeCharacterModel(
      name: _cachedCharacter!.name,
      conversationHistory: _cachedCharacter!.conversationHistory,
      rolePrompt: _cachedCharacter!.rolePrompt,
      props: props,
      animationState: _cachedCharacter!.animationState,
    );
    // TODO: 지속적 저장소에 저장하는 코드 추가
  }

  @override
  Future<bool> isSpecialAnimationUnlocked(String animationName) async {
    // 특별 애니메이션이 잠금 해제되었는지 확인하는 로직
    // 현재는 단순히 모든 특별 애니메이션이 잠금 해제된 것으로 가정
    return true;
  }

  @override
  Future<void> unlockSpecialAnimation(String animationName) async {
    // 특별 애니메이션 잠금 해제 로직
    // TODO: 필요한 경우 특별 애니메이션 잠금 해제 상태를 저장하는 로직 추가
  }

  @override
  Future<List<String>> getAvailableAnimations() async {
    // 사용 가능한 애니메이션 목록 반환
    // 기본 애니메이션은 항상 사용 가능
    final availableAnimations = ['id', 'eye', 'angry', 'happy', 'shine', 'melt'];
    
    // TODO: 잠금 해제된 특별 애니메이션도 추가하는 로직
    
    return availableAnimations;
  }

  @override
  Future<String> getSlimeStateBasedOnGoals() async {
    // 목표 달성 진행도에 따라 슬라임 상태 결정
    // 현재는 단순히 기본 상태 반환
    return 'shine';
  }
}