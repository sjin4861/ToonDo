import 'package:injectable/injectable.dart';
import 'package:domain/repositories/character_repository.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:data/models/slime_character_model.dart';

@LazySingleton(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  SlimeCharacterModel? _cachedCharacter;

  @override
  Future<SlimeCharacter?> getCharacter() async {
    // ...existing code to load character from persistent storage...
    // For the moment, return a dummy character if not cached.
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
  Future<void> updateConversationHistory(String newLine) async {
    // ...existing code to load character from persistent storage...
    if (_cachedCharacter == null) {
      await getCharacter();
    }
    // Update the conversation history.
    _cachedCharacter!.conversationHistory.add(newLine);
    // ...existing code to save updated character in persistent storage...
  }
}
