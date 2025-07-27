import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';

@GenerateMocks([
  CreateTodoUseCase,
  UpdateTodoUseCase,
  GetGoalsLocalUseCase,
])
import 'todo_input_viewmodel_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TodoInputViewModel viewModel;
  late MockCreateTodoUseCase mockCreateTodoUseCase;
  late MockUpdateTodoUseCase mockUpdateTodoUseCase;
  late MockGetGoalsLocalUseCase mockGetGoalsLocalUseCase;

  setUp(() {
    mockCreateTodoUseCase = MockCreateTodoUseCase();
    mockUpdateTodoUseCase = MockUpdateTodoUseCase();
    mockGetGoalsLocalUseCase = MockGetGoalsLocalUseCase();
  });

  group('TodoInputViewModel - 새 투두 생성 모드', () {
    setUp(() {
      viewModel = TodoInputViewModel(
        isDDayTodo: false, // 데일리 투두 모드
        createTodoUseCase: mockCreateTodoUseCase,
        updateTodoUseCase: mockUpdateTodoUseCase,
        getGoalsLocalUseCase: mockGetGoalsLocalUseCase,
      );
    });

    test('초기 상태 검증 - 데일리 투두', () {
      // Given
      // When - 이미 초기화됨
      // Then
      expect(viewModel.titleController.text, isEmpty);
      expect(viewModel.isTitleNotEmpty, false);
      expect(viewModel.selectedGoalId, null);
      expect(viewModel.startDate, null);
      expect(viewModel.endDate, null);
      expect(viewModel.isDailyTodo, true);
      expect(viewModel.importance, 0);
      expect(viewModel.urgency, 0);
    });

    test('초기 상태 검증 - D-day 투두', () {
      // Given
      viewModel = TodoInputViewModel(
        isDDayTodo: true,
        createTodoUseCase: mockCreateTodoUseCase,
        updateTodoUseCase: mockUpdateTodoUseCase,
        getGoalsLocalUseCase: mockGetGoalsLocalUseCase,
      );
      
      // Then
      expect(viewModel.titleController.text, isEmpty);
      expect(viewModel.isTitleNotEmpty, false);
      expect(viewModel.selectedGoalId, null);
      expect(viewModel.isDailyTodo, false);
      expect(viewModel.importance, 0);
      expect(viewModel.urgency, 0);
    });

    test('제목 입력 상태 변경 테스트', () {
      // When
      viewModel.titleController.text = '테스트 투두';
      
      // Then
      expect(viewModel.isTitleNotEmpty, true);
    });

    test('중요도 설정 테스트', () {
      // When
      viewModel.setImportance(1);
      
      // Then
      expect(viewModel.importance, 1);
    });

    test('긴급도 설정 테스트', () {
      // When
      viewModel.setUrgency(1);
      
      // Then
      expect(viewModel.urgency, 1);
    });

    test('아이젠하워 매트릭스 설정 테스트', () {
      // When
      viewModel.setEisenhower(3); // 중요하고 긴급 (1,1)
      
      // Then
      expect(viewModel.importance, 1);
      expect(viewModel.urgency, 1);
      expect(viewModel.selectedEisenhowerIndex, 3);
    });

    test('데일리 투두 모드 변경 테스트', () {
      // 초기에는 데일리 투두(isDailyTodo=true)
      expect(viewModel.isDailyTodo, true);
      
      // When - D-Day 투두로 변경
      viewModel.setDailyTodoStatus(false);
      
      // Then
      expect(viewModel.isDailyTodo, false);
      expect(viewModel.startDate, isNotNull);
      expect(viewModel.endDate, isNotNull);
      
      // When - 다시 데일리 투두로 변경
      viewModel.setDailyTodoStatus(true);
      
      // Then
      expect(viewModel.isDailyTodo, true);
      expect(viewModel.startDate, null);
      expect(viewModel.endDate, null);
    });

    test('목표 선택 테스트', () {
      // Given
      const testGoalId = 'goal-123';
      
      // When
      viewModel.selectGoal(testGoalId);
      
      // Then
      expect(viewModel.selectedGoalId, testGoalId);
      expect(viewModel.showGoalDropdown, false);
    });

    test('목표 목록 표시 토글 테스트', () {
      // Given
      expect(viewModel.showGoalDropdown, false);
      
      // When
      viewModel.toggleGoalDropdown();
      
      // Then
      expect(viewModel.showGoalDropdown, true);
      
      // When
      viewModel.toggleGoalDropdown();
      
      // Then
      expect(viewModel.showGoalDropdown, false);
    });

    test('빈 제목으로 저장 시도 시 에러 메시지 표시', () async {
      // Given
      final mockContext = MockBuildContext();
      
      // When
      await viewModel.saveTodo(mockContext);
      
      // Then
      expect(viewModel.titleError, '투두 이름을 입력해주세요.');
      verifyNever(mockCreateTodoUseCase(any));
    });

    test('투두 생성 성공 테스트', () async {
      // Given
      final mockContext = MockBuildContext();
      viewModel.titleController.text = '테스트 투두';
      when(mockCreateTodoUseCase(any)).thenAnswer((_) async => true);
      
      // When
      await viewModel.saveTodo(mockContext);
      
      // Then
      verify(mockCreateTodoUseCase(any)).called(1);
    });
  });

  group('TodoInputViewModel - 투두 수정 모드', () {
    late Todo testTodo;
    
    setUp(() {
      // 수정할 투두 항목 설정
      testTodo = Todo(
        id: '123',
        title: '테스트 투두',
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 5),
        goalId: 'goal-123',
        importance: 1,
        urgency: 0,
      );
      
      viewModel = TodoInputViewModel(
        todo: testTodo,
        isDDayTodo: true,
        createTodoUseCase: mockCreateTodoUseCase,
        updateTodoUseCase: mockUpdateTodoUseCase,
        getGoalsLocalUseCase: mockGetGoalsLocalUseCase,
      );
    });

    test('초기 상태 검증 - 기존 투두', () {
      expect(viewModel.titleController.text, '테스트 투두');
      expect(viewModel.isTitleNotEmpty, true);
      expect(viewModel.selectedGoalId, 'goal-123');
      expect(viewModel.startDate, DateTime(2025, 5, 1));
      expect(viewModel.endDate, DateTime(2025, 5, 5));
      expect(viewModel.importance, 1);
      expect(viewModel.urgency, 0);
    });

    test('투두 업데이트 테스트', () async {
      // Given
      final mockContext = MockBuildContext();
      viewModel.titleController.text = '수정된 투두';
      viewModel.setImportance(0);
      viewModel.setUrgency(1);
      when(mockUpdateTodoUseCase(any)).thenAnswer((_) async => true);
      
      // When
      await viewModel.saveTodo(mockContext);
      
      // Then
      final captured = verify(mockUpdateTodoUseCase(captureAny)).captured.single as Todo;
      expect(captured.id, '123');
      expect(captured.title, '수정된 투두');
      expect(captured.importance, 0);
      expect(captured.urgency, 1);
    });
  });
}

// Mock BuildContext
class MockBuildContext extends Mock implements BuildContext {}