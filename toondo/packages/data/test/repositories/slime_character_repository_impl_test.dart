// test/slime_repository_impl_test.dart
import 'package:data/datasources/local/animation_local_datasource.dart';
import 'package:data/datasources/remote/gpt_remote_datasource.dart';
import 'package:data/repositories/slime_character_repository_impl.dart';   // 파일명 교체
import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:data/models/slime_character_model.dart';        // 캐릭터 모델
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';                                // Box
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'slime_character_repository_impl_test.mocks.dart';

@GenerateMocks([
  GptRemoteDataSource,
  AnimationLocalDataSource,
  Box<SlimeCharacterModel>,   // ⭐ 추가
])
void main() {
  late SlimeRepository repository;
  late MockGptRemoteDataSource mockGpt;
  late MockAnimationLocalDataSource mockAnim;
  late MockBox<SlimeCharacterModel> mockBox;                    // ⭐

  setUp(() {
    mockGpt  = MockGptRemoteDataSource();
    mockAnim = MockAnimationLocalDataSource();
    mockBox  = MockBox<SlimeCharacterModel>();                  // ⭐

    repository = SlimeRepositoryImpl(
      mockGpt,
      mockAnim,
      mockBox,                                                  // ⭐
    );
  });

  group('SlimeRepositoryImpl', () {
    /* ─── 제스처 테스트 unchanged ─── */

    group('메시지 처리', () {
      test('processMessage → GPT 호출 후 playBySentiment 호출 흐름', () async {
        // Arrange
        const input    = '안녕!';
        const gptReply = '반가워~ 😊';

        when(mockGpt.chat(any)).thenAnswer((_) async => gptReply);

        when(mockAnim.playBySentiment(input, fromUser: true))
            .thenAnswer((_) async => 'idle');
        when(mockAnim.playTyping())
            .thenAnswer((_) async {});
        when(mockAnim.playBySentiment(gptReply, fromUser: false))
            .thenAnswer((_) async => 'happy');

        // Act
        final result = await repository.processMessage(
          text:  input,
          goals: const [],
          todos: const [],
        );

        // Assert
        expect(result.message,      equals(gptReply));
        expect(result.animationKey, equals('happy'));

        verifyInOrder([
          mockAnim.playBySentiment(input,   fromUser: true),
          mockAnim.playTyping(),
          mockGpt.chat(any),
          mockAnim.playBySentiment(gptReply, fromUser: false),
        ]);

        verifyNoMoreInteractions(mockAnim);
      });
    });

    /* 예외 처리·스트림 테스트 등은 동일,
       다만 playBySentiment 호출부에 named 인수(fromUser) 포함해야 함 */
  });
}
