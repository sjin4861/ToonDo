// test/slime_repository_impl_test.dart
import 'package:data/datasources/local/animation_local_datasource.dart';
import 'package:data/datasources/remote/gpt_remote_datasource.dart';
import 'package:data/repositories/slime_character_repository_impl.dart';
import 'package:domain/entities/gesture.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/repositories/slime_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'slime_character_repository_impl_test.mocks.dart';

@GenerateMocks([
  GptRemoteDataSource,
  AnimationLocalDataSource,
])
void main() {
  late SlimeRepository repository;
  late MockGptRemoteDataSource mockGpt;
  late MockAnimationLocalDataSource mockAnim;

  setUp(() {
    mockGpt  = MockGptRemoteDataSource();
    mockAnim = MockAnimationLocalDataSource();

    repository = SlimeRepositoryImpl(mockGpt, mockAnim);
  });

  group('SlimeRepositoryImpl', () {
    group('제스처 처리', () {
      test('processGesture는 playByGesture를 호출하고 키를 반환해야 한다', () async {
        // Arrange
        when(mockAnim.playByGesture(Gesture.tap))
            .thenAnswer((_) async => 'shine');

        // Act
        final result = await repository.processGesture(Gesture.tap);

        // Assert
        expect(result, isA<SlimeResponse>());
        expect(result.animationKey, equals('shine'));
        verify(mockAnim.playByGesture(Gesture.tap)).called(1);
        verifyZeroInteractions(mockGpt);
      });
    });

    group('메시지 처리', () {
      test('processMessage → GPT 호출 후 playBySentiment 호출 흐름', () async {
        // Arrange
        const input = '안녕!';
        const gptReply = '반가워~ 😊';
        when(mockGpt.chat(any)).thenAnswer((_) async => gptReply);
        when(mockAnim.playBySentiment(gptReply))
            .thenAnswer((_) async => 'happy');

        // Act
        final result = await repository.processMessage(
          text: input,
          goals: const [],
          todos: const [],
        );

        // Assert
        expect(result.message, equals(gptReply));
        expect(result.animationKey, equals('happy'));
        verify(mockGpt.chat(any)).called(1);
        verify(mockAnim.playBySentiment(gptReply)).called(1);
      });
    });

    group('대화 모드 토글', () {
      test('chatEnabled 스트림은 setChatEnabled 호출에 따라 값을 방출', () async {
        final expectStream = expectLater(
          repository.chatEnabled$.take(2),
          emitsInOrder([false, true]),
        );

        await repository.setChatEnabled(true);
        await expectStream;
      });
    });

    group('예외 처리', () {
      test('GPT 예외 발생 시 그대로 전파', () async {
        when(mockGpt.chat(any)).thenThrow(Exception('네트워크 오류'));

        expect(
          () => repository.processMessage(text: 'hi'),
          throwsException,
        );
        verify(mockGpt.chat(any)).called(1);
        verifyNever(mockAnim.playBySentiment(any));
      });
    });
  });
}
