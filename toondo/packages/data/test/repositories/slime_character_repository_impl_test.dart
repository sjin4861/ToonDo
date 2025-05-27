// test/slime_character_repository_impl_test.dart
import 'package:data/datasources/local/animation_local_datasource.dart';
import 'package:data/datasources/local/settings_local_datasource.dart';
import 'package:data/repositories/slime_character_repository_impl.dart';
import 'package:data/models/slime_character_model.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/repositories/chat_llm.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'slime_character_repository_impl_test.mocks.dart';

@GenerateMocks([
  ChatLLM,                       // ✅ LLM abstraction (GPT or Gemma)
  AnimationLocalDataSource,
  Box<SlimeCharacterModel>,
  SettingsLocalDataSource,
])
void main() {
  late SlimeRepository            repository;
  late MockChatLLM                mockGpt;
  late MockChatLLM                mockGemma;
  late MockAnimationLocalDataSource mockAnim;
  late MockBox<SlimeCharacterModel> mockBox;
  late MockSettingsLocalDataSource  mockSettings;

  setUp(() {
    mockGpt      = MockChatLLM();
    mockGemma    = MockChatLLM();
    mockAnim     = MockAnimationLocalDataSource();
    mockBox      = MockBox<SlimeCharacterModel>();
    mockSettings = MockSettingsLocalDataSource();

    when(mockSettings.preferredLlm$).thenAnswer((_) => const Stream.empty());

    repository = SlimeRepositoryImpl(
      mockGpt,       // @Named('gpt')
      mockGemma,     // @Named('gemma')
      mockSettings,  // SettingsLocalDataSource
      mockAnim,      // AnimationLocalDataSource
      mockBox,       // Character Box
    );
  });

  group('SlimeRepositoryImpl', () {
    group('메시지 처리', () {
      test('processMessage → LLM 호출 후 playBySentiment 호출 흐름', () async {
        // Arrange
        const input    = '안녕!';
        const llmReply = '반가워~ 😊';

        when(mockGpt.chat(any)).thenAnswer((_) async => llmReply);

        when(mockAnim.playBySentiment(input, fromUser: true))
            .thenAnswer((_) async => 'idle');
        when(mockAnim.playTyping()).thenAnswer((_) async {});
        when(mockAnim.playBySentiment(llmReply, fromUser: false))
            .thenAnswer((_) async => 'happy');

        // Act
        final SlimeResponse result = await repository.processMessage(
          text:  input,
          goals: const [],
          todos: const [],
        );

        // Assert
        expect(result.message,      equals(llmReply));
        expect(result.animationKey, equals('happy'));

        verifyInOrder([
          mockAnim.playBySentiment(input,   fromUser: true),
          mockAnim.playTyping(),
          mockGpt.chat(any),
          mockAnim.playBySentiment(llmReply, fromUser: false),
        ]);

        verifyNoMoreInteractions(mockAnim);
      });
    });
  });
}
