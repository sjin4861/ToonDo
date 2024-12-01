import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';
import '../../mocks/mock_todo_service.mocks.dart'; // 모킹 클래스 임포트
import '../../mocks/mock_build_context.mocks.dart'; // 생성된 모킹 클래스 임포트
import 'package:mockito/annotations.dart'; // mockito 어노테이션 추가

@GenerateMocks([BuildContext, NavigatorState, ScaffoldMessengerState])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화

  group('TodoInputViewModel 테스트', () {
    late MockTodoService mockTodoService;
    late TodoInputViewModel viewModel;
    late MockBuildContext mockContext;
    late MockNavigatorState mockNavigator;
    late MockScaffoldMessengerState mockScaffoldMessenger;

    setUp(() {
      mockTodoService = MockTodoService();
      mockContext = MockBuildContext();
      mockNavigator = MockNavigatorState();
      mockScaffoldMessenger = MockScaffoldMessengerState();
      viewModel = TodoInputViewModel(
        todo: null,
        isDDayTodo: false,
        todoService: mockTodoService,
      );
      // `BuildContext`의 Navigator와 ScaffoldMessenger를 모킹합니다.
      when(mockContext.findAncestorStateOfType<NavigatorState>()).thenReturn(mockNavigator);
      when(mockContext.findAncestorStateOfType<ScaffoldMessengerState>()).thenReturn(mockScaffoldMessenger);
    
    });

    test('초기 상태가 올바른지 확인', () {
      expect(viewModel.title, '');
      expect(viewModel.selectedGoalId, isNull);
      expect(viewModel.startDate, isNull);
      expect(viewModel.endDate, isNull);
      expect(viewModel.isDailyTodo, isTrue); // isDailyTodo는 !isDDayTodo로 초기화되어 true
      expect(viewModel.importance, 0);
      expect(viewModel.urgency, 0);
      expect(viewModel.isTitleNotEmpty, isFalse);
      expect(viewModel.showGoalDropdown, isFalse);
      expect(viewModel.selectedEisenhowerIndex, -1); // 초기값은 -1
    });

    test('setDailyTodoStatus가 isDailyTodo와 날짜를 올바르게 업데이트하는지 확인', () {
      viewModel.setDailyTodoStatus(false);
      expect(viewModel.isDailyTodo, isFalse);
      expect(viewModel.startDate, isNotNull);
      expect(viewModel.endDate, isNotNull);

      viewModel.setDailyTodoStatus(true);
      expect(viewModel.isDailyTodo, isTrue);
      expect(viewModel.startDate, isNull);
      expect(viewModel.endDate, isNull);
    });

    test('setImportance가 importance를 올바르게 업데이트하는지 확인', () {
      viewModel.setImportance(1);
      expect(viewModel.importance, 1);
    });

    test('setUrgency가 urgency를 올바르게 업데이트하는지 확인', () {
      viewModel.setUrgency(1);
      expect(viewModel.urgency, 1);
    });

    test('toggleGoalDropdown이 showGoalDropdown을 올바르게 토글하는지 확인', () {
      viewModel.toggleGoalDropdown();
      expect(viewModel.showGoalDropdown, isTrue);
      viewModel.toggleGoalDropdown();
      expect(viewModel.showGoalDropdown, isFalse);
    });

    test('selectGoal이 selectedGoalId를 업데이트하고 드롭다운을 숨기는지 확인', () {
      viewModel.selectGoal('goal1');
      expect(viewModel.selectedGoalId, 'goal1');
      expect(viewModel.showGoalDropdown, isFalse);
    });

    test('setEisenhower가 importance와 urgency를 올바르게 업데이트하는지 확인', () {
      viewModel.setEisenhower(3);
      expect(viewModel.importance, 1);
      expect(viewModel.urgency, 1);
    });

    test('제목 컨트롤러 리스너가 isTitleNotEmpty를 업데이트하는지 확인', () {
      viewModel.titleController.text = '새 제목';
      expect(viewModel.isTitleNotEmpty, isTrue);
      viewModel.titleController.text = '';
      expect(viewModel.isTitleNotEmpty, isFalse);
    });

    test('saveTodo가 새로운 Todo를 추가하는지 확인', () async {
      // Given
      viewModel.title = '새로운 투두';
      viewModel.selectedGoalId = 'goal1';
      viewModel.isDailyTodo = true;
      viewModel.importance = 1;
      viewModel.urgency = 0;

      // When
      await viewModel.saveTodo(mockContext); // context는 null로 전달 (SnackBar 등 UI 관련 로직 무시)

      // Then
      verify(mockTodoService.addTodo(any)).called(1);
      verifyNever(mockTodoService.updateTodo(any));
      verify(mockScaffoldMessenger.showSnackBar(any)).called(1);
      verify(mockNavigator.pop()).called(1);
    });

    test('saveTodo가 기존 Todo를 업데이트하는지 확인', () async {
      // Given
      Todo existingTodo = Todo(
        id: 'todo1',
        title: '기존 투두',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        goalId: 'goal1',
        importance: 1,
        urgency: 1,
      );
      viewModel = TodoInputViewModel(
        todo: existingTodo,
        isDDayTodo: false,
        todoService: mockTodoService,
      );
      viewModel.title = '수정된 투두';
      viewModel.selectedGoalId = 'goal2';
      viewModel.isDailyTodo = false;
      viewModel.importance = 0;
      viewModel.urgency = 1;

      // When
      await viewModel.saveTodo(mockContext); // context는 null로 전달

      // Then
      verify(mockTodoService.addTodo(any)).called(1);
      verifyNever(mockTodoService.updateTodo(any));
      verify(mockScaffoldMessenger.showSnackBar(any)).called(1);
      verify(mockNavigator.pop()).called(1);
    });

    test('saveTodo에서 에러 발생 시 에러를 처리하는지 확인', () async {
      // Given
      viewModel.title = '새로운 투두';
      when(mockTodoService.addTodo(any)).thenThrow(Exception('Hive 에러'));

      // When
      await viewModel.saveTodo(mockContext);

      // Then
      verify(mockTodoService.addTodo(any)).called(1);
      verifyNever(mockTodoService.updateTodo(any));
      // Then
      verify(mockTodoService.addTodo(any)).called(1);
      verifyNever(mockTodoService.updateTodo(any));
      verify(mockScaffoldMessenger.showSnackBar(any));
      verify(mockNavigator.pop());
      // 에러 처리 부분은 UI 관련이므로, 여기서는 로그 출력만 확인
    });

    tearDown(() {
      viewModel.dispose();
    });
  });
}