import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/goal/get_goals_remote.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:domain/usecases/goal/delete_goal_remote.dart';
import 'package:domain/usecases/goal/delete_goal_local.dart';
import 'package:domain/usecases/goal/get_inprogress_goals.dart';
import 'package:domain/usecases/goal/get_completed_goals.dart';
import 'package:domain/usecases/goal/get_givenup_goals.dart';
import 'package:domain/usecases/goal/update_goal_status.dart';
import 'package:domain/usecases/goal/update_goal_progress.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'goal_management_viewmodel_test.mocks.dart';

// Generate mock classes for GoalManagementViewModel dependencies
@GenerateMocks([
  GetGoalsLocalUseCase,
  GetGoalsRemoteUseCase,
  UpdateGoalRemoteUseCase,
  UpdateGoalLocalUseCase,
  DeleteGoalRemoteUseCase,
  DeleteGoalLocalUseCase,
  GetInProgressGoalsUseCase,
  GetCompletedGoalsUseCase,
  GetGivenUpGoalsUseCase,
  UpdateGoalStatusUseCase,
  UpdateGoalProgressUseCase,
])

void main() {
  late GoalManagementViewModel viewModel;
  late MockGetGoalsLocalUseCase mockGetGoalsLocalUseCase;
  late MockGetGoalsRemoteUseCase mockGetGoalsRemoteUseCase;
  late MockUpdateGoalRemoteUseCase mockUpdateGoalRemoteUseCase;
  late MockUpdateGoalLocalUseCase mockUpdateGoalLocalUseCase;
  late MockDeleteGoalRemoteUseCase mockDeleteGoalRemoteUseCase;
  late MockDeleteGoalLocalUseCase mockDeleteGoalLocalUseCase;
  late MockGetInProgressGoalsUseCase mockGetInProgressGoalsUseCase;
  late MockGetCompletedGoalsUseCase mockGetCompletedGoalsUseCase;
  late MockGetGivenUpGoalsUseCase mockGetGivenUpGoalsUseCase;
  late MockUpdateGoalStatusUseCase mockUpdateGoalStatusUseCase;
  late MockUpdateGoalProgressUseCase mockUpdateGoalProgressUseCase;
  
  late List<Goal> testGoals;
  
  setUp(() {
    mockGetGoalsLocalUseCase = MockGetGoalsLocalUseCase();
    mockGetGoalsRemoteUseCase = MockGetGoalsRemoteUseCase();
    mockUpdateGoalRemoteUseCase = MockUpdateGoalRemoteUseCase();
    mockUpdateGoalLocalUseCase = MockUpdateGoalLocalUseCase();
    mockDeleteGoalRemoteUseCase = MockDeleteGoalRemoteUseCase();
    mockDeleteGoalLocalUseCase = MockDeleteGoalLocalUseCase();
    mockGetInProgressGoalsUseCase = MockGetInProgressGoalsUseCase();
    mockGetCompletedGoalsUseCase = MockGetCompletedGoalsUseCase();
    mockGetGivenUpGoalsUseCase = MockGetGivenUpGoalsUseCase();
    mockUpdateGoalStatusUseCase = MockUpdateGoalStatusUseCase();
    mockUpdateGoalProgressUseCase = MockUpdateGoalProgressUseCase();
    
    testGoals = [
      TestData.createTestGoal(
        id: 'goal-1',
        title: '진행 중인 목표',
        status: Status.active,
        startDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 6, 1)
      ),
      TestData.createTestGoal(
        id: 'goal-2',
        title: '완료된 목표',
        status: Status.completed,
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 4, 1)
      ),
      TestData.createTestGoal(
        id: 'goal-3',
        title: '포기한 목표',
        status: Status.givenUp,
        startDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 5, 1)
      )
    ];
    
    when(mockGetGoalsLocalUseCase.call()).thenAnswer((_) async => testGoals);
    
    final activeGoals = testGoals.where((g) => g.status == Status.active).toList();
    when(mockGetInProgressGoalsUseCase.call()).thenAnswer((_) async => activeGoals);
    
    final completedGoals = testGoals.where((g) => g.status == Status.completed).toList();
    when(mockGetCompletedGoalsUseCase.call()).thenAnswer((_) async => completedGoals);
    
    final givenUpGoals = testGoals.where((g) => g.status == Status.givenUp).toList();
    when(mockGetGivenUpGoalsUseCase.call()).thenAnswer((_) async => givenUpGoals);
    
    viewModel = GoalManagementViewModel(
      getGoalsLocalUseCase: mockGetGoalsLocalUseCase,
      getGoalsRemoteUseCase: mockGetGoalsRemoteUseCase,
      updateGoalRemoteUseCase: mockUpdateGoalRemoteUseCase,
      updateGoalLocalUseCase: mockUpdateGoalLocalUseCase,
      deleteGoalRemoteUseCase: mockDeleteGoalRemoteUseCase,
      deleteGoalLocalUseCase: mockDeleteGoalLocalUseCase,
      getInProgressGoalsUseCase: mockGetInProgressGoalsUseCase,
      getCompletedGoalsUseCase: mockGetCompletedGoalsUseCase,
      getGivenUpGoalsUseCase: mockGetGivenUpGoalsUseCase,
      updateGoalStatusUseCase: mockUpdateGoalStatusUseCase,
      updateGoalProgressUseCase: mockUpdateGoalProgressUseCase,
    );
  });

  group('GoalManagementViewModel', () {
    group('초기화 및 데이터 로드', () {
      test('초기화 시 목표 데이터를 로드하고 기본 필터를 설정해야 한다', () async {
        // wait for constructor-triggered load to complete
        await Future.delayed(Duration.zero);
        // Then
        verify(mockGetGoalsLocalUseCase.call()).called(1);
        expect(viewModel.filterOption, equals(GoalManagementFilterOption.inProgress));
        expect(viewModel.filteredGoals.length, equals(1)); // 진행 중인 목표 1개
      });
      
      test('loadGoals는 로컬 데이터를 갱신하고 필터를 적용해야 한다', () async {
        // When
        await viewModel.loadGoals();
        
        // Then
        verify(mockGetGoalsLocalUseCase.call()).called(2); // 초기 호출 + loadGoals 호출
        verify(mockGetInProgressGoalsUseCase.call()).called(2); // 초기 호출 + loadGoals 호출
      });
    });
    
    group('필터 변경', () {
      test('진행 중인 목표 필터 적용 시 active 상태의 목표만 표시되어야 한다', () async {
        // Given
        when(mockGetInProgressGoalsUseCase.call())
            .thenAnswer((_) async => [testGoals[0]]);
        
        // When
        await viewModel.setFilterOption(GoalManagementFilterOption.inProgress);
        
        // Then
        verify(mockGetInProgressGoalsUseCase.call()).called(2); // 초기 + 필터 변경
        expect(viewModel.filteredGoals.length, equals(1));
        expect(viewModel.filteredGoals[0].id, equals('goal-1'));
        expect(viewModel.filteredGoals[0].status, equals(Status.active));
      });
      
      test('완료된 목표 필터 적용 시 completed 상태의 목표만 표시되어야 한다', () async {
        // Given
        when(mockGetCompletedGoalsUseCase.call())
            .thenAnswer((_) async => [testGoals[1]]);
        
        // When
        await viewModel.setFilterOption(GoalManagementFilterOption.completed);
        
        // Then
        verify(mockGetCompletedGoalsUseCase.call()).called(1);
        expect(viewModel.filteredGoals.length, equals(1));
        expect(viewModel.filteredGoals[0].id, equals('goal-2'));
        expect(viewModel.filteredGoals[0].status, equals(Status.completed));
      });
      
      test('포기한 목표 필터 적용 시 givenUp 상태의 목표만 표시되어야 한다', () async {
        // Given
        when(mockGetGivenUpGoalsUseCase.call())
            .thenAnswer((_) async => [testGoals[2]]);
        
        // When
        await viewModel.setFilterOption(GoalManagementFilterOption.givenUp);
        
        // Then
        verify(mockGetGivenUpGoalsUseCase.call()).called(1);
        expect(viewModel.filteredGoals.length, equals(1));
        expect(viewModel.filteredGoals[0].id, equals('goal-3'));
        expect(viewModel.filteredGoals[0].status, equals(Status.givenUp));
      });
    });
    
    group('목표 관리', () {
      test('목표 삭제 시 원격 및 로컬 삭제가 수행되어야 한다', () async {
        // Given
        const goalId = 'goal-1';
        when(mockDeleteGoalRemoteUseCase.call(goalId))
            .thenAnswer((_) => Future<void>.value());
        when(mockDeleteGoalLocalUseCase.call(goalId))
            .thenAnswer((_) => Future<void>.value());
        
        // When
        await viewModel.deleteGoal(goalId);
        
        // Then
        verify(mockDeleteGoalRemoteUseCase.call(goalId)).called(1);
        verify(mockDeleteGoalLocalUseCase.call(goalId)).called(1);
        verify(mockGetGoalsLocalUseCase.call()).called(2); // 초기 + 삭제 후
      });
      
      test('목표 진행률 업데이트 시 원격 및 로컬 업데이트가 수행되어야 한다', () async {
        // Given
        final targetGoal = testGoals[0];
        const newProgress = 75.0;
        // 업데이트 후 기대되는 Goal 객체
        final updatedGoal = Goal(
          id: targetGoal.id,
          name: targetGoal.name,
          icon: targetGoal.icon,
          progress: newProgress,
          startDate: targetGoal.startDate,
          endDate: targetGoal.endDate,
          status: targetGoal.status,
        );
        
        when(mockUpdateGoalProgressUseCase.call(targetGoal, newProgress))
            .thenAnswer((_) => Future<bool>.value(true));
        when(mockUpdateGoalLocalUseCase.call(updatedGoal))
            .thenAnswer((_) => Future<void>.value());
        
        // When
        await viewModel.updateGoalProgress(targetGoal.id, newProgress);
        
        // Then
        verify(mockUpdateGoalProgressUseCase.call(targetGoal, newProgress)).called(1);
        verify(mockUpdateGoalLocalUseCase.call(updatedGoal)).called(1);
        verify(mockGetGoalsLocalUseCase.call()).called(2); // 초기 + 업데이트 후
      });
      
      test('목표 상태 변경(포기)시 상태가 업데이트되어야 한다', () async {
        // Given
        final targetGoal = testGoals[0];
        
        when(mockUpdateGoalStatusUseCase.call(targetGoal, Status.givenUp))
            .thenAnswer((_) => Future<bool>.value(true));
        
        // When
        await viewModel.giveUpGoal(targetGoal.id);
        
        // Then
        verify(mockUpdateGoalStatusUseCase.call(targetGoal, Status.givenUp)).called(1);
        verify(mockGetGoalsLocalUseCase.call()).called(2); // 초기 + 업데이트 후
      });
      
      test('목표 상태 변경(완료)시 상태가 업데이트되어야 한다', () async {
        // Given
        final targetGoal = testGoals[0];
        
        when(mockUpdateGoalStatusUseCase.call(targetGoal, Status.completed))
            .thenAnswer((_) => Future<bool>.value(true));
        
        // When
        await viewModel.completeGoal(targetGoal.id);
        
        // Then
        verify(mockUpdateGoalStatusUseCase.call(targetGoal, Status.completed)).called(1);
        verify(mockGetGoalsLocalUseCase.call()).called(2); // 초기 + 업데이트 후
      });
    });
  });
}