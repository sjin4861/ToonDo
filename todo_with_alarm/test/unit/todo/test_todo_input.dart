import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';

void main() {
  group('TodoInputViewModel 테스트', () {
    late TodoInputViewModel viewModel;

    setUp(() {
      viewModel = TodoInputViewModel(todo: null, isDDayTodo: false);
    });

    test('초기 상태가 올바른지 확인', () {
      expect(viewModel.title, '');
      expect(viewModel.selectedGoalId, isNull);
      expect(viewModel.startDate, isNull);
      expect(viewModel.endDate, isNull);
      expect(viewModel.isDailyTodo, isTrue);
      expect(viewModel.importance, 0);
      expect(viewModel.urgency, 0);
      expect(viewModel.isTitleNotEmpty, isFalse);
      expect(viewModel.showGoalDropdown, isFalse);
      expect(viewModel.selectedEisenhowerIndex, 0);
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

    tearDown(() {
      viewModel.dispose();
    });
  });
}