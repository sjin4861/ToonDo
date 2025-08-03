import 'package:domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:presentation/designsystem/components/calendars/calendar_bottom_sheet.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:presentation/models/eisenhower_model.dart'; // 여기 EisenhowerType enum이 정의됨

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
  bool isTitleNotEmpty = false;
  bool showGoalDropdown = false;
  String? titleError;
  String? _startDateError;
  String? _endDateError;
  List<Goal> goals = [];

  EisenhowerType _selectedEisenhowerType = EisenhowerType.notImportantNotUrgent;
  EisenhowerType get selectedEisenhowerType => _selectedEisenhowerType;

  int importance = 0;
  int urgency = 0;
  bool isOnboarding;

  String? get startDateError => _startDateError;
  String? get endDateError => _endDateError;

  Todo? todo;
  bool isDDayTodo;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final GetGoalsLocalUseCase _getGoalsLocalUseCase;

  TodoInputViewModel({
    this.todo,
    required this.isDDayTodo,
    required this.isOnboarding,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required GetGoalsLocalUseCase getGoalsLocalUseCase,
  })  : _createTodoUseCase = createTodoUseCase,
        _updateTodoUseCase = updateTodoUseCase,
        _getGoalsLocalUseCase = getGoalsLocalUseCase {
    if (todo != null) {
      titleController.text = todo!.title;
      isTitleNotEmpty = titleController.text.isNotEmpty;
      selectedGoalId = todo!.goalId;
      startDate = todo!.startDate;
      endDate = todo!.endDate;
      importance = todo!.importance.toInt();
      urgency = todo!.urgency.toInt();
      _selectedEisenhowerType = _mapToEisenhowerType(importance, urgency);
      isDailyTodo = todo!.startDate == todo!.endDate;
    } else {
      isDailyTodo = !isDDayTodo;
      if (isDailyTodo) {
        startDate = null;
        endDate = null;
      }
    }

    titleController.addListener(_onTitleChanged);
    _initGoals();
  }

  Future<void> _initGoals() async {
    final result = await _getGoalsLocalUseCase();
    goals = [...result, Goal.empty()];
    notifyListeners();
  }

  EisenhowerType _mapToEisenhowerType(int importance, int urgency) {
    if (importance == 1 && urgency == 1) return EisenhowerType.importantAndUrgent;
    if (importance == 1 && urgency == 0) return EisenhowerType.importantNotUrgent;
    if (importance == 0 && urgency == 1) return EisenhowerType.urgentNotImportant;
    return EisenhowerType.notImportantNotUrgent;
  }

  void setEisenhowerType(EisenhowerType type) {
    _selectedEisenhowerType = type;

    switch (type) {
      case EisenhowerType.notImportantNotUrgent:
        importance = 0;
        urgency = 0;
        break;
      case EisenhowerType.importantNotUrgent:
        importance = 1;
        urgency = 0;
        break;
      case EisenhowerType.urgentNotImportant:
        importance = 0;
        urgency = 1;
        break;
      case EisenhowerType.importantAndUrgent:
        importance = 1;
        urgency = 1;
        break;
    }

    notifyListeners();
  }

  get goalNameError => null;

  Future<List<Goal>> fetchGoals() async {
    final result = await _getGoalsLocalUseCase();
    final goalsWithEmpty = [...result, Goal.empty()];
    return goalsWithEmpty;
  }

  void _onTitleChanged() {
    isTitleNotEmpty = titleController.text.isNotEmpty;
    notifyListeners();
  }

  void onTitleChanged() => _onTitleChanged();

  void setDailyTodoStatus(bool value) {
    isDailyTodo = value;
    if (isDailyTodo) {
      startDate = null;
      endDate = null;
    } else {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(days: 1));
    }
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

  Todo _buildTodo() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedStart = isDailyTodo ? today : (startDate ?? today);
    final normalizedEnd = isDailyTodo ? today : (endDate ?? today);

    return Todo(
      id: todo?.id ?? now.millisecondsSinceEpoch.toString(),
      title: title,
      startDate: normalizedStart,
      endDate: normalizedEnd,
      goalId: selectedGoalId,
      importance: importance,
      urgency: urgency,
    );
  }

  bool _validateStartDate() {
    if (!isDailyTodo && startDate == null) {
      _startDateError = '시작일을 선택해주세요.';
      return false;
    }
    _startDateError = null;
    return true;
  }

  bool _validateEndDate() {
    if (!isDailyTodo && endDate == null) {
      _endDateError = '마감일을 선택해주세요.';
      return false;
    }
    _endDateError = null;
    return true;
  }

  bool _validateDate() {
    final validStart = _validateStartDate();
    final validEnd = _validateEndDate();
    notifyListeners();
    return validStart && validEnd;
  }

  Future<void> createTodo({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    title = titleController.text.trim();
    final isDateValid = _validateDate();
    if (title.isEmpty) {
      onError('투두 제목을 입력해주세요.');
      return;
    }

    if (!isDateValid) {
      onError('날짜를 선택해주세요.');
      return;
    }

    try {
      final newTodo = _buildTodo();
      final created = await _createTodoUseCase(newTodo);
      if (created) {
        onSuccess();
      } else {
        onError('투두 생성에 실패했어요.');
      }
    } catch (e) {
      onError('에러 발생: $e');
    }
  }

  Future<void> updateTodo({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    title = titleController.text.trim();
    final isDateValid = _validateDate();
    if (title.isEmpty) {
      onError('투두 제목을 입력해주세요.');
      return;
    }

    if (!isDateValid) {
      onError('날짜를 선택해주세요.');
      return;
    }

    try {
      final updatedTodo = _buildTodo();
      await _updateTodoUseCase(updatedTodo);
      onSuccess();
    } catch (e) {
      onError('업데이트 중 오류 발생: $e');
    }
  }

  @override
  void dispose() {
    titleController.removeListener(_onTitleChanged);
    titleController.dispose();
    super.dispose();
  }
}
