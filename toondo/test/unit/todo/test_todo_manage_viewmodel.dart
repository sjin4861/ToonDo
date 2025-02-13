import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/data/repositories/todo_repository.dart';
import 'package:toondo/ui/todo/todo_manage/todo_manage_viewmodel.dart';

import '../../mocks/mock_todo_repository.dart';

void main() {
  late MockTodoRepository mockRepo;
  late TodoManageViewModel viewModel;

  setUp(() {
    GetIt.instance.reset();
    mockRepo = MockTodoRepository();
    // GetIt에 TodoRepository 등록
    GetIt.instance.registerSingleton<TodoRepository>(mockRepo);
    viewModel = TodoManageViewModel(todoRepository: mockRepo);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  test('loadTodos 호출 시 fetchTodos와 getLocalTodos가 정상적으로 불리는지 확인', () async {
    // ...existing code...
    when(mockRepo.getLocalTodos()).thenReturn([]);
    when(mockRepo.fetchTodos()).thenAnswer((_) async => []);

    await viewModel.loadTodos();
    // loadTodos 내부에서 getLocalTodos가 두 번 호출됨
    verify(mockRepo.getLocalTodos()).called(2);
    verify(mockRepo.fetchTodos()).called(1);
  });

  test('updateSelectedDate 호출 시 selectedDate 변경 및 필터 적용 확인', () async {
    final testDate = DateTime(2023, 07, 01);
    viewModel.updateSelectedDate(testDate);
    expect(viewModel.selectedDate, testDate);
  });

  test('updateSelectedFilter 호출 시 selectedFilter 변경 및 필터 적용 확인', () {
    viewModel.updateSelectedFilter(FilterOption.goal, goalId: 'goal123');
    expect(viewModel.selectedFilter, FilterOption.goal);
    expect(viewModel.selectedGoalId, 'goal123');
  });

  test('deleteTodoById 호출 시 해당 Todo 삭제되었는지 확인', () async {
    final dummyTodo = Todo(
      id: 'testId',
      title: 'test',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
    );
    when(mockRepo.getLocalTodos()).thenReturn([dummyTodo]);
    await viewModel.loadTodos();

    await viewModel.deleteTodoById('testId');
    verify(mockRepo.deleteTodo(dummyTodo)).called(1);
  });

  test('updateTodoDates 정상 동작 확인', () async {
    final dummyTodo = Todo(
      id: 'dummy',
      title: 'dummy todo',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
    );
    when(mockRepo.getLocalTodos()).thenReturn([dummyTodo]);
    await viewModel.loadTodos();

    final newStart = DateTime.now().add(const Duration(days: 2));
    final newEnd = DateTime.now().add(const Duration(days: 3));
    await viewModel.updateTodoDates(dummyTodo, newStart, newEnd);

    verify(mockRepo.updateTodo(dummyTodo)).called(1);
    expect(dummyTodo.startDate, newStart);
    expect(dummyTodo.endDate, newEnd);
  });

  test('updateTodoStatus 호출 시 Todo status가 갱신되는지 확인', () async {
    final dummyTodo = Todo(
      id: 'dummy',
      title: 'dummy todo',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
      status: 0,
    );
    when(mockRepo.getLocalTodos()).thenReturn([dummyTodo]);
    await viewModel.loadTodos();

    await viewModel.updateTodoStatus(dummyTodo, 0.5);
    expect(dummyTodo.status, 0.5);
    verify(mockRepo.updateTodo(dummyTodo)).called(1);
  });
}
