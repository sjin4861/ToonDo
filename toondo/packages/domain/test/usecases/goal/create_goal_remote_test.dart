import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/entities/status.dart';
import '../../mocks/mock_goal_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late CreateGoalRemoteUseCase useCase;
  late MockGoalRepository mockRepository;

  setUp(() {
    mockRepository = MockGoalRepository();
    useCase = CreateGoalRemoteUseCase(mockRepository);
  });

  group('CreateGoalRemoteUseCase', () {
    test('목표가 성공적으로 생성되어야 한다', () async {
      // Arrange
      final goalToCreate = TestData.createTestGoal(
        id: 'temp-id',
        name: '새로운 목표',
      );
      final createdGoal = TestData.createTestGoal(
        id: 'created-goal-id',
        name: '새로운 목표',
      );
      when(mockRepository.createGoalRemote(goalToCreate))
          .thenAnswer((_) async => createdGoal);

      // Act
      final result = await useCase.call(goalToCreate);

      // Assert
      expect(result, equals(createdGoal));
      expect(result.id, equals('created-goal-id'));
      expect(result.name, equals('새로운 목표'));
      verify(mockRepository.createGoalRemote(goalToCreate)).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      final goalToCreate = TestData.createTestGoal(id: 'temp', name: '새로운 목표');
      when(mockRepository.createGoalRemote(goalToCreate))
          .thenThrow(Exception('목표 생성 실패'));

      // Act & Assert
      expect(() => useCase.call(goalToCreate), throwsException);
      verify(mockRepository.createGoalRemote(goalToCreate)).called(1);
    });

    test('여러 목표를 순차적으로 생성할 수 있어야 한다', () async {
      // Arrange
      final goal1 = TestData.createTestGoal(id: 'temp1', name: '목표 1');
      final goal2 = TestData.createTestGoal(id: 'temp2', name: '목표 2');
      final goal3 = TestData.createTestGoal(id: 'temp3', name: '목표 3');
      
      final createdGoal1 = TestData.createTestGoal(id: 'goal-1', name: '목표 1');
      final createdGoal2 = TestData.createTestGoal(id: 'goal-2', name: '목표 2');
      final createdGoal3 = TestData.createTestGoal(id: 'goal-3', name: '목표 3');

      when(mockRepository.createGoalRemote(goal1))
          .thenAnswer((_) async => createdGoal1);
      when(mockRepository.createGoalRemote(goal2))
          .thenAnswer((_) async => createdGoal2);
      when(mockRepository.createGoalRemote(goal3))
          .thenAnswer((_) async => createdGoal3);

      // Act
      final result1 = await useCase.call(goal1);
      final result2 = await useCase.call(goal2);
      final result3 = await useCase.call(goal3);

      // Assert
      expect(result1.id, equals('goal-1'));
      expect(result2.id, equals('goal-2'));
      expect(result3.id, equals('goal-3'));
      verify(mockRepository.createGoalRemote(goal1)).called(1);
      verify(mockRepository.createGoalRemote(goal2)).called(1);
      verify(mockRepository.createGoalRemote(goal3)).called(1);
    });

    test('목표 생성 시 모든 속성이 올바르게 전달되어야 한다', () async {
      // Arrange
      final goalToCreate = TestData.createTestGoal(
        id: 'temp',
        name: '운동 목표',
        status: Status.inProgress,
        progress: 0.3,
      );
      final createdGoal = TestData.createTestGoal(
        id: 'exercise-goal',
        name: '운동 목표',
        status: Status.inProgress,
        progress: 0.3,
      );
      when(mockRepository.createGoalRemote(goalToCreate))
          .thenAnswer((_) async => createdGoal);

      // Act
      final result = await useCase.call(goalToCreate);

      // Assert
      expect(result.name, equals('운동 목표'));
      expect(result.status, equals(Status.inProgress));
      expect(result.progress, equals(0.3));
      verify(mockRepository.createGoalRemote(goalToCreate)).called(1);
    });

    test('목표 생성 중 일부 목표에서 예외가 발생해도 다른 목표는 정상 생성되어야 한다', () async {
      // Arrange
      final goal1 = TestData.createTestGoal(id: 'temp1', name: '목표 1');
      final goal2 = TestData.createTestGoal(id: 'temp2', name: '목표 2'); // 이것은 실패
      final goal3 = TestData.createTestGoal(id: 'temp3', name: '목표 3');
      
      final createdGoal1 = TestData.createTestGoal(id: 'goal-1', name: '목표 1');
      final createdGoal3 = TestData.createTestGoal(id: 'goal-3', name: '목표 3');

      when(mockRepository.createGoalRemote(goal1))
          .thenAnswer((_) async => createdGoal1);
      when(mockRepository.createGoalRemote(goal2))
          .thenThrow(Exception('목표 2 생성 실패'));
      when(mockRepository.createGoalRemote(goal3))
          .thenAnswer((_) async => createdGoal3);

      // Act
      final result1 = await useCase.call(goal1); // 성공
      
      // goal2 생성 시 예외 발생
      expect(() => useCase.call(goal2), throwsException);
      
      final result3 = await useCase.call(goal3); // 성공

      // Assert
      expect(result1.id, equals('goal-1'));
      expect(result3.id, equals('goal-3'));
      verify(mockRepository.createGoalRemote(goal1)).called(1);
      verify(mockRepository.createGoalRemote(goal2)).called(1);
      verify(mockRepository.createGoalRemote(goal3)).called(1);
    });
  });
}
