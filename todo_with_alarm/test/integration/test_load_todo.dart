import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/todo_submission_viewmodel.dart';

void main() {
  test('Adding a new todo should not remove existing todos', () async {
    TodoService todoService = TodoService();
    TodoSubmissionViewModel viewModel = TodoSubmissionViewModel();

    // 기존 투두 추가
    Todo existingTodo = Todo(
      id: '1',
      title: 'Existing Todo',
      startDate: DateTime(2023, 11, 15),
      endDate: DateTime(2023, 11, 15),
    );
    await todoService.addTodoToStorage(existingTodo);

    // 새로운 투두 추가
    Todo newTodo = Todo(
      id: '2',
      title: 'New Todo',
      startDate: DateTime(2023, 11, 15),
      endDate: DateTime(2023, 11, 15),
    );
    await todoService.addTodoToStorage(newTodo);

    // 투두 로드
    await viewModel.loadTodos();

    // 투두 개수 확인
    expect(viewModel.allTodos.length, 2);
    expect(viewModel.allTodos.any((todo) => todo.id == '1'), true);
    expect(viewModel.allTodos.any((todo) => todo.id == '2'), true);
  });
}