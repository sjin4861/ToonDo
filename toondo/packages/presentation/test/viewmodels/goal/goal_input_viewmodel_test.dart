import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import '../../helpers/test_data.dart';
import 'goal_input_viewmodel_test.mocks.dart';

// Generate mock classes for use cases and BuildContext
@GenerateMocks([
  CreateGoalRemoteUseCase,
  SaveGoalLocalUseCase,
  UpdateGoalRemoteUseCase,
  UpdateGoalLocalUseCase,
  BuildContext,
])

void main() {
  late GoalInputViewModel viewModel;
  late MockCreateGoalRemoteUseCase mockCreateGoalRemoteUseCase;
  late MockSaveGoalLocalUseCase mockSaveGoalLocalUseCase;
  late MockUpdateGoalRemoteUseCase mockUpdateGoalRemoteUseCase;
  late MockUpdateGoalLocalUseCase mockUpdateGoalLocalUseCase;
  late MockBuildContext mockBuildContext;
  
  setUp(() {
    mockCreateGoalRemoteUseCase = MockCreateGoalRemoteUseCase();
    mockSaveGoalLocalUseCase = MockSaveGoalLocalUseCase();
    mockUpdateGoalRemoteUseCase = MockUpdateGoalRemoteUseCase();
    mockUpdateGoalLocalUseCase = MockUpdateGoalLocalUseCase();
    mockBuildContext = MockBuildContext();
    
    // 기본 ViewModel - 새로운 목표 생성 모드
    viewModel = GoalInputViewModel(
      createGoalRemoteUseCase: mockCreateGoalRemoteUseCase,
      saveGoalLocalUseCase: mockSaveGoalLocalUseCase,
      updateGoalRemoteUseCase: mockUpdateGoalRemoteUseCase,
      updateGoalLocalUseCase: mockUpdateGoalLocalUseCase,
    );
  });
  
  tearDown(() {
    viewModel.dispose();
  });
  
  group('GoalInputViewModel', () {
    group('초기 상태', () {
      test('초기 상태는 빈 값과 기본 설정을 가져야 한다', () {
        // Then
        expect(viewModel.goalNameController.text, isEmpty);
        expect(viewModel.startDate, isNull);
        expect(viewModel.endDate, isNull);
        expect(viewModel.selectedIcon, isNull);
        expect(viewModel.goalNameError, isNull);
        expect(viewModel.dateError, isNull);
        expect(viewModel.targetGoal, isNull);
      });
      
      test('기존 목표를 수정하는 경우 해당 정보로 초기화되어야 한다', () {
        // Given
        final existingGoal = TestData.createTestGoal(
          id: 'existing-goal',
          title: '기존 목표',
          icon: 'assets/icons/ic_100point.svg',
        );
        
        // When - 기존 목표로 뷰모델 초기화
        viewModel = GoalInputViewModel(
          createGoalRemoteUseCase: mockCreateGoalRemoteUseCase,
          saveGoalLocalUseCase: mockSaveGoalLocalUseCase,
          updateGoalRemoteUseCase: mockUpdateGoalRemoteUseCase,
          updateGoalLocalUseCase: mockUpdateGoalLocalUseCase,
          targetGoal: existingGoal,
        );
        
        // Then
        expect(viewModel.goalNameController.text, equals('기존 목표'));
        expect(viewModel.startDate, equals(existingGoal.startDate));
        expect(viewModel.endDate, equals(existingGoal.endDate));
        expect(viewModel.selectedIcon, equals(existingGoal.icon));
        expect(viewModel.targetGoal, equals(existingGoal));
      });
    });
    
    group('입력값 검증', () {
      test('이름이 빈 경우 유효성 검사에 실패해야 한다', () {
        // Given
        viewModel.goalNameController.text = '';
        viewModel.startDate = DateTime(2025, 5, 1);
        viewModel.endDate = DateTime(2025, 5, 31);
        
        // When
        final result = viewModel.validateInput();
        
        // Then
        expect(result, isFalse);
        expect(viewModel.goalNameError, equals('목표 이름을 입력해주세요.'));
      });
      
      test('날짜가 설정되지 않은 경우 유효성 검사에 실패해야 한다', () {
        // Given
        viewModel.goalNameController.text = '테스트 목표';
        
        // When
        final result = viewModel.validateInput();
        
        // Then
        expect(result, isFalse);
        expect(viewModel.dateError, equals('시작일과 마감일을 모두 선택해주세요.'));
      });
      
      test('마감일이 시작일보다 이전인 경우 유효성 검사에 실패해야 한다', () {
        // Given
        viewModel.goalNameController.text = '테스트 목표';
        viewModel.startDate = DateTime(2025, 5, 10);
        viewModel.endDate = DateTime(2025, 5, 1);
        
        // When
        final result = viewModel.validateInput();
        
        // Then
        expect(result, isFalse);
        expect(viewModel.dateError, equals('마감일은 시작일 이후여야 합니다.'));
      });
      
      test('모든 필드가 올바르게 입력된 경우 유효성 검사에 성공해야 한다', () {
        // Given
        viewModel.goalNameController.text = '테스트 목표';
        viewModel.startDate = DateTime(2025, 5, 1);
        viewModel.endDate = DateTime(2025, 5, 31);
        
        // When
        final result = viewModel.validateInput();
        
        // Then
        expect(result, isTrue);
        expect(viewModel.goalNameError, isNull);
        expect(viewModel.dateError, isNull);
      });
    });
    
    group('목표 저장', () {
      test('새로운 목표 성공적으로 저장되어야 한다', () async {
        // Given
        viewModel.goalNameController.text = '테스트 목표';
        viewModel.startDate = DateTime(2025, 5, 1);
        viewModel.endDate = DateTime(2025, 5, 31);
        viewModel.selectedIcon = 'assets/icons/ic_100point.svg';
        
        final createdGoal = TestData.createTestGoal(
          id: 'new-goal-id',
          title: '테스트 목표',
          icon: 'assets/icons/ic_100point.svg',
          startDate: viewModel.startDate,
          endDate: viewModel.endDate
        );
        
        when(mockCreateGoalRemoteUseCase.call(createdGoal))
            .thenAnswer((_) async => createdGoal);
        when(mockSaveGoalLocalUseCase.call(createdGoal))
            .thenAnswer((_) async {});
        
        // When
        final result = await viewModel.saveGoal(mockBuildContext);
        
        // Then
        verify(mockCreateGoalRemoteUseCase.call(createdGoal)).called(1);
        verify(mockSaveGoalLocalUseCase.call(createdGoal)).called(1);
        expect(result, isNotNull);
        expect(result?.id, equals('new-goal-id'));
        expect(result?.name, equals('테스트 목표'));
      });
      
      test('기존 목표가 성공적으로 업데이트되어야 한다', () async {
        // Given
        final existingGoal = TestData.createTestGoal(
          id: 'existing-goal',
          title: '기존 목표'
        );
        
        // 기존 목표로 뷰모델 초기화
        viewModel = GoalInputViewModel(
          createGoalRemoteUseCase: mockCreateGoalRemoteUseCase,
          saveGoalLocalUseCase: mockSaveGoalLocalUseCase,
          updateGoalRemoteUseCase: mockUpdateGoalRemoteUseCase,
          updateGoalLocalUseCase: mockUpdateGoalLocalUseCase,
          targetGoal: existingGoal,
        );
        
        // 필드 값 변경
        viewModel.goalNameController.text = '수정된 목표';
        viewModel.startDate = DateTime(2025, 6, 1);
        viewModel.endDate = DateTime(2025, 6, 30);
        // Updated goal 객체 정의
        final updatedGoal = Goal(
          id: existingGoal.id,
          name: '수정된 목표',
          icon: existingGoal.icon,
          startDate: viewModel.startDate!,
          endDate: viewModel.endDate!,
          progress: existingGoal.progress,
        );
        
        when(mockUpdateGoalRemoteUseCase.call(updatedGoal))
            .thenAnswer((_) async {});
        when(mockUpdateGoalLocalUseCase.call(updatedGoal))
            .thenAnswer((_) async {});
        
        // When
        final result = await viewModel.saveGoal(mockBuildContext);
        
        // Then
        verify(mockUpdateGoalRemoteUseCase.call(updatedGoal)).called(1);
        verify(mockUpdateGoalLocalUseCase.call(updatedGoal)).called(1);
        expect(result, isNotNull);
        expect(result?.id, equals('existing-goal'));
        expect(result?.name, equals('수정된 목표'));
      });
      
      test('유효성 검증 실패 시 목표를 저장하지 않아야 한다', () async {
        // Given - 이름 필드 비움
        viewModel.goalNameController.text = '';
        
        // When
        final result = await viewModel.saveGoal(mockBuildContext);
        
        // Then
        verifyZeroInteractions(mockCreateGoalRemoteUseCase);
        verifyZeroInteractions(mockSaveGoalLocalUseCase);
        expect(result, isNull);
      });
      
      test('저장 중 예외 발생 시 null을 반환해야 한다', () async {
        // Given
        viewModel.goalNameController.text = '테스트 목표';
        viewModel.startDate = DateTime(2025, 5, 1);
        viewModel.endDate = DateTime(2025, 5, 31);
        // 실제 Goal 객체 생성
        final createdGoal = TestData.createTestGoal(
          title: '테스트 목표',
          icon: 'assets/icons/ic_100point.svg',
          startDate: viewModel.startDate,
          endDate: viewModel.endDate
        );

        when(mockCreateGoalRemoteUseCase.call(createdGoal))
            .thenThrow(Exception('서버 오류'));
        
        // When
        final result = await viewModel.saveGoal(mockBuildContext);
        
        // Then
        verify(mockCreateGoalRemoteUseCase.call(createdGoal)).called(1);
        verifyZeroInteractions(mockSaveGoalLocalUseCase);
        expect(result, isNull);
      });
    });
    
    group('날짜 및 아이콘 설정', () {
      test('selectStartDate는 시작일을 업데이트해야 한다', () {
        // Given
        final newStartDate = DateTime(2025, 5, 10);
        
        // When
        viewModel.selectStartDate(newStartDate);
        
        // Then
        expect(viewModel.startDate, equals(newStartDate));
      });
      
      test('selectEndDate는 마감일을 업데이트해야 한다', () {
        // Given
        final newEndDate = DateTime(2025, 5, 20);
        
        // When
        viewModel.selectEndDate(newEndDate);
        
        // Then
        expect(viewModel.endDate, equals(newEndDate));
      });
      
      test('시작일이 마감일보다 늦는 경우 마감일이 자동으로 조정되어야 한다', () {
        // Given
        final initialEndDate = DateTime(2025, 5, 10);
        final laterStartDate = DateTime(2025, 5, 15);
        viewModel.endDate = initialEndDate;
        
        // When
        viewModel.selectStartDate(laterStartDate);
        
        // Then
        expect(viewModel.endDate, equals(laterStartDate));
      });
      
      test('마감일이 시작일보다 이른 경우 시작일이 자동으로 조정되어야 한다', () {
        // Given
        final initialStartDate = DateTime(2025, 5, 15);
        final earlierEndDate = DateTime(2025, 5, 10);
        viewModel.startDate = initialStartDate;
        
        // When
        viewModel.selectEndDate(earlierEndDate);
        
        // Then
        expect(viewModel.startDate, equals(earlierEndDate));
      });
      
      test('selectIcon은 선택된 아이콘을 업데이트해야 한다', () {
        // Given
        const iconPath = 'assets/icons/ic_heart_with_arrow.svg';
        
        // When
        viewModel.selectIcon(iconPath);
        
        // Then
        expect(viewModel.selectedIcon, equals(iconPath));
      });
    });
  });
}