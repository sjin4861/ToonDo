import 'package:injectable/injectable.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_character.dart';

@LazySingleton(as: SlimeRepository)
class SlimeRepositoryImpl implements SlimeRepository {
  
  @override
  Future<SlimeResponse> processGesture(Gesture gesture) async {
    // 임시 구현: 제스처에 따른 기본 애니메이션 반환
    String animationKey;
    switch (gesture) {
      case Gesture.tap:
        animationKey = 'happy';
        break;
      case Gesture.doubleTap:
        animationKey = 'jump';
        break;
      case Gesture.longPress:
        animationKey = 'happy';
        break;
      case Gesture.drag:
        animationKey = 'angry';
        break;
      default:
        animationKey = 'id';
    }
    
    return SlimeResponse(animationKey: animationKey);
  }

  @override
  Future<SlimeCharacter?> getCharacter() async {
    // 임시 구현: 기본 슬라임 캐릭터 반환
    return const SlimeCharacter(
      name: '슬라임',
      conversationHistory: [],
      rolePrompt: '너는 귀여운 슬라임이야.',
      props: [],
      animationState: 'id',
    );
  }
}
