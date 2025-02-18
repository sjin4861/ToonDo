import 'package:domain/entities/slime_character.dart';

abstract class CharacterRepository {
  Future<SlimeCharacter?> getCharacter();
  Future<void> updateConversationHistory(String newLine);
}
