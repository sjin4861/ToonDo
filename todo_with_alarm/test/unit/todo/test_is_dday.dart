import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/models/todo.dart';

void main() {
  group('Todo isDDayTodo Method', () {
    test('Should return false when startDate and endDate are the same', () {
      Todo todo = Todo(
        title: 'Test Todo',
        startDate: DateTime(2023, 11, 15),
        endDate: DateTime(2023, 11, 15),
      );
      expect(todo.isDDayTodo(), false);
    });

    test('Should return true when startDate and endDate are different', () {
      Todo todo = Todo(
        title: 'Test Todo',
        startDate: DateTime(2023, 11, 15),
        endDate: DateTime(2023, 11, 16),
      );
      expect(todo.isDDayTodo(), true);
    });
  });
}