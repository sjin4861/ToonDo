import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import '../../mocks/mock_goal_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late GetGoalsLocalUseCase useCase;
  late MockGoalRepository mockRepository;

  setUp(() {
    mockRepository = MockGoalRepository();
    useCase = GetGoalsLocalUseCase(mockRepository);
  });

  group('GetGoalsLocalUseCase', () {
    test('로컬 목표 목록이 성공적으로 반환되어야 한다', () async {
      // Arrange
      final goals = [
        TestData.createTestGoal(id: 'goal-1', name: '목표 1'),
        TestData.createTestGoal(id: 'goal-2', name: '목표 2'),
        TestData.createTestGoal(id: 'goal-3', name: '목표 3'),
      ];
      when(mockRepository.getGoalsLocal()).thenReturn(goals);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(goals));
      expect(result.length, equals(3));
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('빈 목표 목록이 반환되어야 한다', () async {
      // Arrange
      when(mockRepository.getGoalsLocal()).thenReturn(<Goal>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      when(mockRepository.getGoalsLocal()).thenThrow(Exception('로컬 데이터 읽기 실패'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('매번 호출할 때마다 Repository를 호출해야 한다', () async {
      // Arrange
      final goals = [TestData.createTestGoal(id: 'goal-1')];
      when(mockRepository.getGoalsLocal()).thenReturn(goals);

      // Act
      await useCase.call();
      await useCase.call();
      await useCase.call();

      // Assert
      verify(mockRepository.getGoalsLocal()).called(3);
    });

    test('다양한 상태의 목표들이 모두 포함되어야 한다', () async {
      // Arrange
      final goals = [
        TestData.createTestGoal(id: 'goal-1', status: Status.active),
        TestData.createTestGoal(id: 'goal-2', status: Status.inProgress),
        TestData.createTestGoal(id: 'goal-3', status: Status.completed),
        TestData.createTestGoal(id: 'goal-4', status: Status.givenUp),
      ];
      when(mockRepository.getGoalsLocal()).thenReturn(goals);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(4));
      expect(result.map((goal) => goal.status).toSet(), 
             equals({Status.active, Status.inProgress, Status.completed, Status.givenUp}));
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('반환된 목표 목록의 순서가 Repository에서 반환한 순서와 동일해야 한다', () async {
      // Arrange
      final goals = [
        TestData.createTestGoal(id: 'goal-3', name: 'C'),
        TestData.createTestGoal(id: 'goal-1', name: 'A'),
        TestData.createTestGoal(id: 'goal-2', name: 'B'),
      ];
      when(mockRepository.getGoalsLocal()).thenReturn(goals);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result[0].name, equals('C'));
      expect(result[1].name, equals('A'));
      expect(result[2].name, equals('B'));
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('다양한 진행도를 가진 목표들이 올바르게 반환되어야 한다', () async {
      // Arrange
      final goals = [
        TestData.createTestGoal(id: 'goal-1', progress: 0.0),   // 시작 안함
        TestData.createTestGoal(id: 'goal-2', progress: 0.25),  // 25% 진행
        TestData.createTestGoal(id: 'goal-3', progress: 0.5),   // 50% 진행
        TestData.createTestGoal(id: 'goal-4', progress: 0.75),  // 75% 진행
        TestData.createTestGoal(id: 'goal-5', progress: 1.0),   // 완료
      ];
      when(mockRepository.getGoalsLocal()).thenReturn(goals);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(5));
      expect(result[0].progress, equals(0.0));
      expect(result[1].progress, equals(0.25));
      expect(result[2].progress, equals(0.5));
      expect(result[3].progress, equals(0.75));
      expect(result[4].progress, equals(1.0));
      verify(mockRepository.getGoalsLocal()).called(1);
    });

    test('로컬 저장소가 비어있을 때 빈 목록을 반환해야 한다', () async {
      // Arrange
      when(mockRepository.getGoalsLocal()).thenReturn([]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      expect(result, isA<List<Goal>>());
      verify(mockRepository.getGoalsLocal()).called(1);
    });
  });
}
