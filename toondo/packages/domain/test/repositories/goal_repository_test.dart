import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_data.dart';
import '../mocks/mock_goal_repository.dart';

void main() {
  late MockGoalRepository repository;
  
  setUp(() {
    repository = MockGoalRepository();
  });

  group('GoalRepository 로컬 메서드 테스트', () {
    test('getGoalsLocal 메서드는 로컬 목표 리스트를 반환해야 한다', () {
      // Arrange
      final expectedGoals = TestData.createTestGoals();
      when(repository.getGoalsLocal()).thenReturn(expectedGoals);
      
      // Act
      final result = repository.getGoalsLocal();
      
      // Assert
      expect(result, equals(expectedGoals));
      verify(repository.getGoalsLocal()).called(1);
    });
    
    test('getGoalByIdLocal 메서드는 ID로 로컬 목표를 조회해야 한다', () async {
      // Arrange
      final expectedGoal = TestData.createTestGoal(id: 'test_goal_1');
      when(repository.getGoalByIdLocal('test_goal_1'))
          .thenAnswer((_) async => expectedGoal);
      
      // Act
      final result = await repository.getGoalByIdLocal('test_goal_1');
      
      // Assert
      expect(result, equals(expectedGoal));
      verify(repository.getGoalByIdLocal('test_goal_1')).called(1);
    });
    
    test('getGoalByIdLocal 메서드는 존재하지 않는 ID로 조회 시 null을 반환해야 한다', () async {
      // Arrange
      when(repository.getGoalByIdLocal('non_existing_id'))
          .thenAnswer((_) async => null);
      
      // Act
      final result = await repository.getGoalByIdLocal('non_existing_id');
      
      // Assert
      expect(result, isNull);
      verify(repository.getGoalByIdLocal('non_existing_id')).called(1);
    });
    
    test('saveGoalLocal 메서드는 로컬에 목표를 저장해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(id: 'test_goal_save');
      when(repository.saveGoalLocal(goal)).thenAnswer((_) async => null);
      
      // Act
      await repository.saveGoalLocal(goal);
      
      // Assert
      verify(repository.saveGoalLocal(goal)).called(1);
    });
    
    test('updateGoalLocal 메서드는 로컬 목표를 업데이트해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(
        id: 'test_goal_update', 
        name: '업데이트된 목표',
        progress: 0.5,
      );
      when(repository.updateGoalLocal(goal)).thenAnswer((_) async => null);
      
      // Act
      await repository.updateGoalLocal(goal);
      
      // Assert
      verify(repository.updateGoalLocal(goal)).called(1);
    });
    
    test('deleteGoalLocal 메서드는 로컬에서 목표를 삭제해야 한다', () async {
      // Arrange
      const goalId = 'test_goal_delete';
      when(repository.deleteGoalLocal(goalId)).thenAnswer((_) async => null);
      
      // Act
      await repository.deleteGoalLocal(goalId);
      
      // Assert
      verify(repository.deleteGoalLocal(goalId)).called(1);
    });
  });
  
  group('GoalRepository 원격 메서드 테스트', () {
    test('fetchGoalsRemote 메서드는 서버에서 목표 리스트를 가져와야 한다', () async {
      // Arrange
      final expectedGoals = TestData.createTestGoals();
      when(repository.fetchGoalsRemote())
          .thenAnswer((_) async => expectedGoals);
      
      // Act
      final result = await repository.fetchGoalsRemote();
      
      // Assert
      expect(result, equals(expectedGoals));
      verify(repository.fetchGoalsRemote()).called(1);
    });
    
    test('createGoalRemote 메서드는 서버에 목표를 생성하고 생성된 목표를 반환해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(id: 'remote_goal_1');
      final createdGoal = TestData.createTestGoal(
        id: 'server_generated_id',
        name: goal.name,
        progress: goal.progress,
        startDate: goal.startDate,
        endDate: goal.endDate,
      );
      
      when(repository.createGoalRemote(goal))
          .thenAnswer((_) async => createdGoal);
      
      // Act
      final result = await repository.createGoalRemote(goal);
      
      // Assert
      expect(result, equals(createdGoal));
      expect(result.id, equals('server_generated_id'));
      verify(repository.createGoalRemote(goal)).called(1);
    });
    
    test('updateGoalStatusRemote 메서드는 서버에서 목표의 상태를 업데이트해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(id: 'status_update_goal');
      const newStatus = Status.completed;
      
      when(repository.updateGoalStatusRemote(goal, newStatus))
          .thenAnswer((_) async => true);
      
      // Act
      final result = await repository.updateGoalStatusRemote(goal, newStatus);
      
      // Assert
      expect(result, isTrue);
      verify(repository.updateGoalStatusRemote(goal, newStatus)).called(1);
    });
    
    test('updateGoalProgressRemote 메서드는 서버에서 목표의 진행률을 업데이트해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(id: 'progress_update_goal');
      const newProgress = 0.75;
      
      when(repository.updateGoalProgressRemote(goal, newProgress))
          .thenAnswer((_) async => true);
      
      // Act
      final result = await repository.updateGoalProgressRemote(goal, newProgress);
      
      // Assert
      expect(result, isTrue);
      verify(repository.updateGoalProgressRemote(goal, newProgress)).called(1);
    });
    
    test('updateGoalRemote 메서드는 서버에서 목표 전체 정보를 업데이트해야 한다', () async {
      // Arrange
      final goal = TestData.createTestGoal(
        id: 'full_update_goal',
        name: '전체 업데이트 목표',
        progress: 0.6,
        status: Status.paused,
      );
      
      when(repository.updateGoalRemote(goal))
          .thenAnswer((_) async => null);
      
      // Act
      await repository.updateGoalRemote(goal);
      
      // Assert
      verify(repository.updateGoalRemote(goal)).called(1);
    });
    
    test('deleteGoalRemote 메서드는 서버에서 목표를 삭제해야 한다', () async {
      // Arrange
      const goalId = 'remote_delete_goal';
      when(repository.deleteGoalRemote(goalId))
          .thenAnswer((_) async => null);
      
      // Act
      await repository.deleteGoalRemote(goalId);
      
      // Assert
      verify(repository.deleteGoalRemote(goalId)).called(1);
    });
  });

  group('GoalRepository 통합 테스트', () {
    test('로컬 및 원격 저장소 동기화 테스트', () async {
      // Arrange
      final remoteGoals = TestData.createTestGoals(count: 2);
      final localGoals = [
        TestData.createTestGoal(id: 'local_goal_1'),
        TestData.createTestGoal(id: 'local_goal_2'),
      ];
      
      when(repository.fetchGoalsRemote())
          .thenAnswer((_) async => remoteGoals);
      when(repository.getGoalsLocal())
          .thenReturn(localGoals);
      
      // Act - 원격 데이터를 가져온 후 로컬에도 저장
      final fetchedGoals = await repository.fetchGoalsRemote();
      for (final goal in fetchedGoals) {
        when(repository.saveGoalLocal(goal))
            .thenAnswer((_) async => null);
        await repository.saveGoalLocal(goal);
      }
      
      // Assert
      verify(repository.fetchGoalsRemote()).called(1);
      for (final goal in fetchedGoals) {
        verify(repository.saveGoalLocal(goal)).called(1);
      }
    });
    
    test('목표 생성 및 업데이트 통합 테스트', () async {
      // Arrange
      final newGoal = TestData.createTestGoal(id: 'new_goal');
      final createdGoal = TestData.createTestGoal(
        id: 'server_id_123',
        name: newGoal.name,
        startDate: newGoal.startDate,
        endDate: newGoal.endDate,
      );
      
      // 원격 저장소에 목표 생성 설정
      when(repository.createGoalRemote(newGoal))
          .thenAnswer((_) async => createdGoal);
          
      // 로컬 저장소에 목표 저장 설정  
      when(repository.saveGoalLocal(createdGoal))
          .thenAnswer((_) async => null);
      
      // Act - 목표 생성 후 로컬에 저장
      final resultGoal = await repository.createGoalRemote(newGoal);
      await repository.saveGoalLocal(resultGoal);
      
      // 목표 업데이트 (상태와 진행률 변경)
      final updatedGoal = TestData.createTestGoal(
        id: resultGoal.id,
        name: resultGoal.name,
        progress: 0.7,
        status: Status.completed,
        startDate: resultGoal.startDate,
        endDate: resultGoal.endDate,
      );
      
      when(repository.updateGoalRemote(updatedGoal))
          .thenAnswer((_) async => null);
      when(repository.updateGoalLocal(updatedGoal))
          .thenAnswer((_) async => null);
      
      // 원격 및 로컬에 업데이트
      await repository.updateGoalRemote(updatedGoal);
      await repository.updateGoalLocal(updatedGoal);
      
      // Assert
      verify(repository.createGoalRemote(newGoal)).called(1);
      verify(repository.saveGoalLocal(resultGoal)).called(1);
      verify(repository.updateGoalRemote(updatedGoal)).called(1);
      verify(repository.updateGoalLocal(updatedGoal)).called(1);
    });
  });
}