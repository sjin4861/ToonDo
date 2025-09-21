import 'package:domain/entities/todo_filter_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// Add annotations for generating mocks
import 'package:mockito/annotations.dart';
import 'todo_manage_viewmodel_test.mocks.dart';

import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import '../../helpers/test_data.dart';

// Generate mock classes for use cases
@GenerateMocks([
  DeleteTodoUseCase,
  GetAllTodosUseCase,
  UpdateTodoStatusUseCase,
  UpdateTodoDatesUseCase,
  GetGoalsLocalUseCase,
])
void main() {
  late TodoManageViewModel viewModel;
  late MockDeleteTodoUseCase mockDeleteTodoUseCase;
  late MockGetAllTodosUseCase mockGetAllTodosUseCase;
  late MockUpdateTodoStatusUseCase mockUpdateTodoStatusUseCase;
  late MockUpdateTodoDatesUseCase mockUpdateTodoDatesUseCase;
  late MockGetGoalsLocalUseCase mockGetGoalsLocalUseCase;

  final testDate = DateTime(2025, 5, 5);
  late List<Todo> testTodos;
  late List<Goal> testGoals;

  setUp(() {
    mockDeleteTodoUseCase = MockDeleteTodoUseCase();
    mockGetAllTodosUseCase = MockGetAllTodosUseCase();
    mockUpdateTodoStatusUseCase = MockUpdateTodoStatusUseCase();
    mockUpdateTodoDatesUseCase = MockUpdateTodoDatesUseCase();
    mockGetGoalsLocalUseCase = MockGetGoalsLocalUseCase();

    testTodos = TestData.createTestTodos();
    testGoals = TestData.createTestGoals();

    when(mockGetAllTodosUseCase.call()).thenAnswer((_) async => testTodos);
    when(mockGetGoalsLocalUseCase.call()).thenAnswer((_) async => testGoals);

    viewModel = TodoManageViewModel(
      deleteTodoUseCase: mockDeleteTodoUseCase,
      getTodosUseCase: mockGetAllTodosUseCase,
      updateTodoStatusUseCase: mockUpdateTodoStatusUseCase,
      updateTodoDatesUseCase: mockUpdateTodoDatesUseCase,
      getGoalsLocalUseCase: mockGetGoalsLocalUseCase,
      initialDate: testDate,
    );
  });

  group('TodoManageViewModel', () {
    group('초기 상태 및 데이터 로드', () {
      test('초기 상태는 선택된 날짜와 기본 필터 설정을 가져야 한다', () {
        // Then
        expect(viewModel.selectedDate, equals(testDate));
        expect(viewModel.selectedFilter, equals(TodoFilterOption.all));
        expect(viewModel.selectedGoalId, isNull);
        expect(viewModel.allTodos.isEmpty, isTrue);
        expect(viewModel.dDayTodos.isEmpty, isTrue);
        expect(viewModel.dailyTodos.isEmpty, isTrue);
        expect(viewModel.goals.isEmpty, isTrue);
      });

      test('loadTodos는 로컬에서 모든 투두와 목표를 가져와야 한다', () async {
        // When
        await viewModel.loadTodos();

        // Then
        verify(mockGetAllTodosUseCase.call()).called(1);
        verify(mockGetGoalsLocalUseCase.call()).called(1);
        expect(viewModel.allTodos.length, 4); // TestData에서 생성한 투두 4개
        expect(viewModel.dDayTodos.length, 2); // D-Day 투두 2개
        expect(viewModel.dailyTodos.length, 2); // 데일리 투두 2개
        expect(viewModel.goals.length, 2); // 테스트 목표 2개
      });

      test('getTodos는 모든 투두를 반환해야 한다', () async {
        // When
        final result = await viewModel.getTodos();

        // Then
        expect(result, equals(testTodos));
        verify(mockGetAllTodosUseCase.call()).called(1);
      });
    });

    group('날짜 및 필터 업데이트', () {
      setUp(() async {
        // 각 테스트 실행 전에 투두 데이터 로드
        await viewModel.loadTodos();
      });

      test('날짜 선택 변경 시 해당 날짜의 투두만 필터링되어야 한다', () {
        // Given
        final newDate = DateTime(2025, 5, 10);

        // When
        viewModel.updateSelectedDate(newDate);

        // Then
        expect(viewModel.selectedDate, newDate);
        // 새 날짜(5월 10일)에는 D-Day 투두 하나만 해당됨 (5월 10일까지 진행되는)
        expect(viewModel.dDayTodos.length, 1);
        expect(viewModel.dailyTodos.length, 0);
      });

      test('목표별 필터링 시 해당 목표의 투두만 표시되어야 한다', () {
        // Given
        const targetGoalId = 'goal-1';

        // When
        viewModel.updateSelectedFilter(
          TodoFilterOption.goal,
          goalId: targetGoalId,
        );

        // Then
        expect(viewModel.selectedFilter, TodoFilterOption.goal);
        expect(viewModel.selectedGoalId, targetGoalId);

        // goal-1에 해당하는 투두만 필터링되어야 함
        expect(viewModel.dDayTodos.length, 1);
        expect(viewModel.dailyTodos.length, 1);
        expect(
          viewModel.dDayTodos.every((todo) => todo.goalId == targetGoalId),
          isTrue,
        );
        expect(
          viewModel.dailyTodos.every((todo) => todo.goalId == targetGoalId),
          isTrue,
        );
      });

      test('중요도별 필터링 시 중요도가 높은 투두만 표시되어야 한다', () {
        // eisenhower 필터 테스트 - 중요한 항목들(eisenhower >= 2) 필터링
        // When
        viewModel.updateSelectedFilter(TodoFilterOption.importance);

        // Then
        expect(viewModel.selectedFilter, TodoFilterOption.importance);

        // eisenhower 값이 2 이상인 투두만 필터링되어야 함 (중요한 항목들)
        expect(viewModel.dDayTodos.length, 1);
        expect(viewModel.dailyTodos.length, 1);
        expect(
          viewModel.dDayTodos.every((todo) => todo.eisenhower >= 2),
          isTrue,
        );
        expect(
          viewModel.dailyTodos.every((todo) => todo.eisenhower >= 2),
          isTrue,
        );
      });

      test('D-Day 투두 필터링 시 D-Day 투두만 표시되어야 한다', () {
        // When
        viewModel.updateSelectedFilter(TodoFilterOption.dDay);

        // Then
        expect(viewModel.selectedFilter, TodoFilterOption.dDay);

        // D-Day 투두만 있어야 함
        expect(viewModel.dDayTodos.length, 2);
        expect(viewModel.dailyTodos.length, 0);
      });

      test('데일리 투두 필터링 시 데일리 투두만 표시되어야 한다', () {
        // When
        viewModel.updateSelectedFilter(TodoFilterOption.daily);

        // Then
        expect(viewModel.selectedFilter, TodoFilterOption.daily);

        // 데일리 투두만 있어야 함
        expect(viewModel.dDayTodos.length, 0);
        expect(viewModel.dailyTodos.length, 2);
      });

      test('목표 선택 시 해당 목표의 투두만 필터링되어야 한다', () {
        // Given
        final targetGoal = testGoals[1]; // goal-2

        // When
        viewModel.updateSelectedGoal(targetGoal);

        // Then
        expect(viewModel.selectedGoalId, 'goal-2');
        expect(viewModel.selectedFilter, TodoFilterOption.goal);

        // goal-2에 해당하는 투두만 필터링되어야 함
        expect(viewModel.dDayTodos.length, 1);
        expect(viewModel.dailyTodos.length, 1);
        expect(
          viewModel.dDayTodos.every((todo) => todo.goalId == 'goal-2'),
          isTrue,
        );
        expect(
          viewModel.dailyTodos.every((todo) => todo.goalId == 'goal-2'),
          isTrue,
        );
      });
    });

    group('투두 관리', () {
      setUp(() async {
        // 각 테스트 실행 전에 투두 데이터 로드
        await viewModel.loadTodos();
      });

      test('updateTodoStatus는 투두 상태를 업데이트해야 한다', () async {
        // Given
        final targetTodo = testTodos[0];
        const newStatus = 0.5; // 50% 완료
        when(
          mockUpdateTodoStatusUseCase.call(targetTodo, newStatus),
        ).thenAnswer((_) => Future<void>.value());

        // When
        await viewModel.updateTodoStatus(targetTodo, newStatus);

        // Then
        verify(
          mockUpdateTodoStatusUseCase.call(targetTodo, newStatus),
        ).called(1);

        // 업데이트된 투두를 확인 - 내부 리스트에서 상태가 변경되어야 함
        final updatedTodo = viewModel.allTodos.firstWhere(
          (todo) => todo.id == targetTodo.id,
        );
        expect(updatedTodo.status, equals(newStatus));
      });

      test('deleteTodoById는 투두를 삭제하고 데이터를 다시 로드해야 한다', () async {
        // Given
        final targetTodo = testTodos[0];
        final targetTodoId = targetTodo.id;
        when(
          mockDeleteTodoUseCase.call(targetTodo),
        ).thenAnswer((_) => Future<void>.value());

        // When
        await viewModel.deleteTodoById(targetTodoId);

        // Then
        verify(mockDeleteTodoUseCase.call(targetTodo)).called(1);
        verify(mockGetAllTodosUseCase.call()).called(2); // 초기 로드 + 삭제 후 다시 로드
      });

      test('updateTodoDates는 투두 날짜를 업데이트하고 데이터를 다시 로드해야 한다', () async {
        // Given
        final targetTodo = testTodos[0];
        final newStartDate = DateTime(2025, 5, 15);
        final newEndDate = DateTime(2025, 5, 20);

        when(
          mockUpdateTodoDatesUseCase.call(targetTodo, newStartDate, newEndDate),
        ).thenAnswer((_) => Future<void>.value());

        // When
        await viewModel.updateTodoDates(targetTodo, newStartDate, newEndDate);

        // Then
        verify(
          mockUpdateTodoDatesUseCase.call(targetTodo, newStartDate, newEndDate),
        ).called(1);
        verify(mockGetAllTodosUseCase.call()).called(2); // 초기 로드 + 업데이트 후 다시 로드
      });
    });
  });
}
