import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/widgets/calendar/calendar_bottom_sheet.dart';

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
  int urgency = 0;    // 긴급도 (0 또는 1)
  bool isTitleNotEmpty = false;
  bool showGoalDropdown = false;
  int selectedEisenhowerIndex = -1;

  Todo? todo;
  bool isDDayTodo;
  late TodoService _todoService;

  TodoInputViewModel({required this.todo, required this.isDDayTodo, required TodoService todoService}) {
    _todoService = todoService;
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


  Future<void> selectDate(BuildContext context, {required bool isStartDate}) async {
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
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        // 투두 생성 또는 업데이트
        Todo newTodo = Todo(
          id: todo?.id,
          title: title,
          startDate: isDailyTodo ? DateTime.now() : (startDate ?? DateTime.now()),
          endDate: isDailyTodo ? DateTime.now() : (endDate ?? DateTime.now()),
          goalId: selectedGoalId,
          importance: importance.toInt(), // 중요도 저장
          urgency: urgency.toInt(),       // 긴급도 저장
          // 기타 필요한 필드 설정
        );
        if (todo != null) {
          // 수정 모드이면 new todo의 id를 제외한 모든 성질을 todo로 복사
          todo!.updateFrom(newTodo);
          await _todoService.updateTodo(todo!);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('투두가 성공적으로 수정되었습니다.')),
          // );
        } else {
          // 새로 추가
          await _todoService.addTodo(newTodo);
        }
        Navigator.pop(context); // 투두 페이지로 돌아가기
      } catch (e) {
        // 에러 처리 로직 추가 (예: 로그 기록, 사용자 알림 등)
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