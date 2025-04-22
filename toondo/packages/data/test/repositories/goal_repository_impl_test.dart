import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:data/repositories/goal_repository_impl.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import '../mocks/mock_goal_local_datasource.dart';
import '../mocks/mock_goal_remote_datasource.dart';

void main() {
  late GoalRepository repository;
  late MockGoalLocalDatasource mockLocalDatasource;
  late MockGoalRemoteDataSource mockRemoteDatasource;

  setUp(() {
    mockLocalDatasource = MockGoalLocalDatasource();
    mockRemoteDatasource = MockGoalRemoteDataSource();
    repository = GoalRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
    );
  });

  group('GoalRepositoryImpl', () {
    group('로컬 데이터 테스트', () {
      test('getGoalsLocal은 로컬 데이터소스의 getAllGoals를 호출해야 한다', () {
        // Arrange
        final testGoals = TestData.createTestGoals();
        when(mockLocalDatasource.getAllGoals()).thenReturn(testGoals);
        
        // Act
        final result = repository.getGoalsLocal();
        
        // Assert
        expect(result, equals(testGoals));
        verify(mockLocalDatasource.getAllGoals()).called(1);
      });

      test('getGoalByIdLocal은 로컬 데이터소스에서 특정 ID의 목표를 가져와야 한다', () async {
        // Arrange
        final goalId = 'goal_1';
        final testGoal = TestData.createTestGoal(id: goalId);
        final testGoals = [testGoal, TestData.createTestGoal(id: 'goal_2')];
        when(mockLocalDatasource.getAllGoals()).thenReturn(testGoals);
        
        // Act
        final result = await repository.getGoalByIdLocal(goalId);
        
        // Assert
        expect(result, equals(testGoal));
        verify(mockLocalDatasource.getAllGoals()).called(1);
      });

      test('saveGoalLocal은 로컬 데이터소스의 saveGoal을 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        
        // Act
        await repository.saveGoalLocal(goal);
        
        // Assert
        verify(mockLocalDatasource.saveGoal(goal)).called(1);
      });
      
      test('updateGoalLocal은 로컬 데이터소스의 updateGoal을 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        
        // Act
        await repository.updateGoalLocal(goal);
        
        // Assert
        verify(mockLocalDatasource.updateGoal(goal)).called(1);
      });
      
      test('deleteGoalLocal은 로컬 데이터소스의 deleteGoal을 호출해야 한다', () async {
        // Arrange
        final goalId = 'goal_1';
        
        // Act
        await repository.deleteGoalLocal(goalId);
        
        // Assert
        verify(mockLocalDatasource.deleteGoal(goalId)).called(1);
      });
    });
    
    group('원격 데이터 테스트', () {
      test('fetchGoalsRemote는 원격 데이터소스의 readGoals를 호출해야 한다', () async {
        // Arrange
        final testGoals = TestData.createTestGoals();
        when(mockRemoteDatasource.readGoals()).thenAnswer((_) async => testGoals);
        
        // Act
        final result = await repository.fetchGoalsRemote();
        
        // Assert
        expect(result, equals(testGoals));
        verify(mockRemoteDatasource.readGoals()).called(1);
      });
      
      test('createGoalRemote는 원격 데이터소스의 createGoal을 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        when(mockRemoteDatasource.createGoal(goal)).thenAnswer((_) async => goal);
        
        // Act
        final result = await repository.createGoalRemote(goal);
        
        // Assert
        expect(result, equals(goal));
        verify(mockRemoteDatasource.createGoal(goal)).called(1);
      });
      
      test('updateGoalStatusRemote는 원격 데이터소스의 updateGoalStatus를 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        final newStatus = Status.completed;
        when(mockRemoteDatasource.updateGoalStatus(goal, newStatus)).thenAnswer((_) async => true);
        
        // Act
        final result = await repository.updateGoalStatusRemote(goal, newStatus);
        
        // Assert
        expect(result, isTrue);
        verify(mockRemoteDatasource.updateGoalStatus(goal, newStatus)).called(1);
      });
      
      test('updateGoalProgressRemote는 원격 데이터소스의 updateGoalProgress를 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        final newProgress = 75.0;
        when(mockRemoteDatasource.updateGoalProgress(goal, newProgress)).thenAnswer((_) async => true);
        
        // Act
        final result = await repository.updateGoalProgressRemote(goal, newProgress);
        
        // Assert
        expect(result, isTrue);
        verify(mockRemoteDatasource.updateGoalProgress(goal, newProgress)).called(1);
      });
      
      test('updateGoalRemote는 원격 데이터소스의 updateGoal을 호출해야 한다', () async {
        // Arrange
        final goal = TestData.createTestGoal(id: 'goal_1');
        
        // Act
        await repository.updateGoalRemote(goal);
        
        // Assert
        verify(mockRemoteDatasource.updateGoal(goal)).called(1);
      });
      
      test('deleteGoalRemote는 원격 데이터소스의 deleteGoal을 호출해야 한다', () async {
        // Arrange
        final goalId = 'goal_1';
        
        // Act
        await repository.deleteGoalRemote(goalId);
        
        // Assert
        verify(mockRemoteDatasource.deleteGoal(goalId)).called(1);
      });
    });
  });
}