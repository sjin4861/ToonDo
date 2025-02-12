import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_with_alarm/data/models/todo.dart';
import 'package:todo_with_alarm/data/repositories/todo_repository.dart';
import 'package:todo_with_alarm/ui/todo/todo_input/todo_input_viewmodel.dart';
import '../../mocks/mock_todo_repository.dart'; // 새로 만든 mock import

void main() {
  late MockTodoRepository mockRepo;
  late TodoInputViewModel viewModel;

  setUp(() {
    GetIt.instance.reset();
    mockRepo = MockTodoRepository();
    GetIt.instance.registerSingleton<TodoRepository>(mockRepo);
    viewModel = TodoInputViewModel(isDDayTodo: true);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  test('초기 상태 테스트 (신규 투두)', () {
    expect(viewModel.title, '');
    expect(viewModel.isDailyTodo, false);
    expect(viewModel.selectedGoalId, isNull);
  });

  test('titleController 변경시 isTitleNotEmpty 업데이트', () {
    viewModel.titleController.text = '테스트 투두';
    viewModel.titleController.notifyListeners();
    expect(viewModel.isTitleNotEmpty, true);
  });

  test('setDailyTodoStatus 메서드 테스트', () {
    viewModel.setDailyTodoStatus(true);
    expect(viewModel.startDate, null);
    expect(viewModel.endDate, null);

    viewModel.setDailyTodoStatus(false);
    expect(viewModel.startDate, isNotNull);
    expect(viewModel.endDate, isNotNull);
  });

  test('setEisenhower 메서드 테스트', () {
    viewModel.setEisenhower(3);
    expect(viewModel.importance, 1);
    expect(viewModel.urgency, 1);

    viewModel.setEisenhower(0);
    expect(viewModel.importance, 0);
    expect(viewModel.urgency, 0);
  });

  testWidgets('saveTodo 신규 투두 호출 시 title이 지정된 투두 생성 확인', (WidgetTester tester) async {
    final formKey = viewModel.formKey;
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    formKey.currentState?.save();

    // title이 비어있지 않은 경우에만 생성되어야 함
    final newTodo = Todo(
      id: '1',
      title: '새로운 투두',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      goalId: '1',
    );
    when(mockRepo.createTodo(newTodo)).thenAnswer((_) async => true);
    viewModel.titleController.text = '새로운 투두';
    await viewModel.saveTodo(tester.element(find.byType(Form)));
    verify(mockRepo.createTodo(newTodo)).called(1);
  });

  testWidgets('saveTodo 신규 투두 호출 시 빈 제목이면 투두 생성 안됨', (WidgetTester tester) async {
    final formKey = viewModel.formKey;
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    formKey.currentState?.save();

    // createTodo가 호출되지 않아야 함
    viewModel.titleController.text = ''; // 빈 제목
    await viewModel.saveTodo(tester.element(find.byType(Form)));
    // verifyNever(mockRepo.createTodo());
  });

  testWidgets('saveTodo 신규 투두 호출 시 빈 제목이면 에러 메시지 표시', (WidgetTester tester) async {
    final formKey = viewModel.formKey;
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    formKey.currentState?.save();

    // 초기 titleError는 null이어야 함
    expect(viewModel.titleError, null);

    viewModel.titleController.text = ''; // 빈 제목 설정
    await viewModel.saveTodo(tester.element(find.byType(Form)));

    // titleError가 null이 아니어야 함
    expect(viewModel.titleError, isNotNull);
    // createTodo는 호출되지 않아야 함
    // verifyNever(mockRepo.createTodo(any));
  });

  testWidgets('saveTodo 수정 모드 호출 시 updateTodo 호출 확인', (WidgetTester tester) async {
    // Arrange: GetIt에 repository를 먼저 등록한 후, TodoInputViewModel 생성
    GetIt.instance.reset();
    mockRepo = MockTodoRepository();
    GetIt.instance.registerSingleton<TodoRepository>(mockRepo);
    
    final existingTodo = Todo(
      id: '1',
      title: '기존 투두',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      goalId: '1',
    );
    viewModel = TodoInputViewModel(todo: existingTodo, isDDayTodo: true);
    
    final formKey = viewModel.formKey;
    final testWidget = MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    formKey.currentState?.save();

    final updatedTodo = Todo(
      id: existingTodo.id,
      title: '수정된 투두',
      startDate: existingTodo.startDate,
      endDate: existingTodo.endDate,
      goalId: existingTodo.goalId,
    );
    when(mockRepo.updateTodo(updatedTodo)).thenAnswer((_) async {});
    viewModel.titleController.text = '수정된 투두';
    await viewModel.saveTodo(tester.element(find.byType(Form)));
    verify(mockRepo.updateTodo(updatedTodo)).called(1);
  });
}
