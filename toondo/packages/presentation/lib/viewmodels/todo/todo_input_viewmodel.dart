import 'package:domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
import 'package:presentation/widgets/calendar/calendar_bottom_sheet.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class TodoInputViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy년 M월 d일');

  String title = '';
  String? selectedGoalId;
  DateTime? startDate;
  DateTime? endDate;
  bool isDailyTodo = false;
  int importance = 0; // 중요도 (0 또는 1)
  int urgency = 0; // 긴급도 (0 또는 1)
  bool isTitleNotEmpty = false;
  bool showGoalDropdown = false;
  int selectedEisenhowerIndex = -1;
  String? titleError; // title 에러 메시지 상태 추가

  Todo? todo;
  bool isDDayTodo;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final GoalViewModel _goalViewModel;

  TodoInputViewModel({
    this.todo,
    required this.isDDayTodo,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required GoalViewModel goalViewModel,
  }) : _createTodoUseCase = createTodoUseCase,
       _updateTodoUseCase = updateTodoUseCase,
       _goalViewModel = goalViewModel {
    if (todo != null) {
      // 수정 모드
      titleController.text = todo!.title;
      isTitleNotEmpty = titleController.text.isNotEmpty;
      selectedGoalId = todo!.goalId;
      startDate = todo!.startDate;
      endDate = todo!.endDate;
      importance = todo!.importance.toInt();
      urgency = todo!.urgency.toInt();
      isDailyTodo = todo!.startDate == todo!.endDate;
    } else {
      // 새로 추가 모드
      isDailyTodo = !isDDayTodo;
      if (isDailyTodo) {
        startDate = null;
        endDate = null;
      }
    }
    titleController.addListener(_onTitleChanged);
  }

  get goalNameError => null;

  List<Goal> get goals => _goalViewModel.goals;

  void _onTitleChanged() {
    isTitleNotEmpty = titleController.text.isNotEmpty;
    notifyListeners();
  }

  void setDailyTodoStatus(bool value) {
    isDailyTodo = value;
    if (isDailyTodo) {
      startDate = null;
      endDate = null;
    } else {
      startDate = DateTime.now();
      endDate = DateTime.now().add(Duration(days: 1));
    }
    notifyListeners();
  }

  void setImportance(int value) {
    importance = value; // 중요도 설정 (0 또는 1)
    notifyListeners();
  }

  void setUrgency(int value) {
    urgency = value; // 긴급도 설정 (0 또는 1)
    notifyListeners();
  }

  void toggleGoalDropdown() {
    showGoalDropdown = !showGoalDropdown;
    notifyListeners();
  }

  void selectGoal(String? goalId) {
    selectedGoalId = goalId;
    showGoalDropdown = false;
    notifyListeners();
  }

  void setEisenhower(int index) {
    selectedEisenhowerIndex = index;
    switch (index) {
      case 0:
        importance = 0;
        urgency = 0;
        break;
      case 1:
        importance = 1;
        urgency = 0;
        break;
      case 2:
        importance = 0;
        urgency = 1;
        break;
      case 3:
        importance = 1;
        urgency = 1;
        break;
      default:
        importance = 0;
        urgency = 0;
        break;
    }
    notifyListeners();
  }

  Future<void> selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    DateTime initialDate = DateTime.now();
    if (isStartDate && startDate != null) {
      initialDate = startDate!;
    } else if (!isStartDate && endDate != null) {
      initialDate = endDate!;
    }

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (context) => SelectDateBottomSheet(initialDate: initialDate),
    );

    if (pickedDate != null) {
      if (isStartDate) {
        startDate = pickedDate;
        if (endDate != null && startDate!.isAfter(endDate!)) {
          endDate = startDate;
        }
      } else {
        endDate = pickedDate;
        if (startDate != null && endDate!.isBefore(startDate!)) {
          startDate = endDate;
        }
      }
      notifyListeners();
    }
  }

  Future<void> saveTodo(BuildContext context) async {
    titleError = null; // 초기화
    title = titleController.text.trim();
    if (title.isEmpty) {
      titleError = '투두 이름을 입력해주세요.';
      notifyListeners();
      return; // 빈 제목이면 여기서 종료
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        Todo newTodo = Todo(
          id: todo!.id,
          title: title,
          startDate:
              isDailyTodo ? DateTime.now() : (startDate ?? DateTime.now()),
          endDate: isDailyTodo ? DateTime.now() : (endDate ?? DateTime.now()),
          goalId: selectedGoalId,
          importance: importance,
          urgency: urgency,
        );
        if (todo != null) {
          await _updateTodoUseCase(todo!);
        } else {
          await _createTodoUseCase(newTodo);
        }
        Navigator.pop(context);
      } catch (e) {
        print('Error saving todo: $e');
      }
    }
  }

  @override
  void dispose() {
    titleController.removeListener(_onTitleChanged);
    titleController.dispose();
    super.dispose();
  }
}
