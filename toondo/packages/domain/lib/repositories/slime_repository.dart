import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:domain/entities/slime_response.dart';

abstract class SlimeRepository {
  // Gesture recognition and response
  Future<SlimeResponse> processGesture(Gesture gesture);

  // Character information for animations
  Future<SlimeCharacter?> getCharacter();
}