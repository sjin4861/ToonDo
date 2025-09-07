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
  bool showOnHome = false;
  String? titleError;
  String? _startDateError;
  String? _endDateError;
  List<Goal> goals = [];

  EisenhowerType _selectedEisenhowerType = EisenhowerType.notImportantNotUrgent;
  EisenhowerType get selectedEisenhowerType => _selectedEisenhowerType;

  bool isOnboarding;

  String? get startDateError => _startDateError;
  String? get endDateError => _endDateError;

  Todo? todo;
  bool isDDayTodo;
  final CreateTodoUseCase _createTodoUseCase;
  final UpdateTodoUseCase _updateTodoUseCase;
  final GetGoalsLocalUseCase _getGoalsLocalUseCase;
  final String? initialGoalId; // 새로 생성된 목표 전달용

  TodoInputViewModel({
    this.todo,
    required this.isDDayTodo,
    required this.isOnboarding,
    required CreateTodoUseCase createTodoUseCase,
    required UpdateTodoUseCase updateTodoUseCase,
    required GetGoalsLocalUseCase getGoalsLocalUseCase,
  this.initialGoalId,
  }) : _createTodoUseCase = createTodoUseCase,
       _updateTodoUseCase = updateTodoUseCase,
       _getGoalsLocalUseCase = getGoalsLocalUseCase {
    if (todo != null) {
      titleController.text = todo!.title;
      isTitleNotEmpty = titleController.text.isNotEmpty;
      selectedGoalId = todo!.goalId;
      startDate = todo!.startDate;
      endDate = todo!.endDate;
      showOnHome = todo!.showOnHome;
      // eisenhower 필드에서 EisenhowerType으로 매핑
      _selectedEisenhowerType = _mapEisenhowerToType(todo!.eisenhower);
      isDailyTodo = todo!.startDate == todo!.endDate;
    } else {
      isDailyTodo = !isDDayTodo;
      if (isDailyTodo) {
        startDate = null;
        endDate = null;
      }
    }

    // 새 목표에서 넘어온 경우 자동 연결
    if (initialGoalId != null && selectedGoalId == null) {
      selectedGoalId = initialGoalId;
    }

    titleController.addListener(_onTitleChanged);
    _initGoals();
  }

  Future<void> _initGoals() async {
    final result = await _getGoalsLocalUseCase();
    goals = [...result, Goal.empty()];
    notifyListeners();
  }

  // eisenhower 값을 EisenhowerType으로 매핑
  EisenhowerType _mapEisenhowerToType(int eisenhower) {
    switch (eisenhower) {
      case 0:
        return EisenhowerType.notImportantNotUrgent;
      case 1:
        return EisenhowerType.urgentNotImportant;
      case 2:
        return EisenhowerType.importantNotUrgent;
      case 3:
        return EisenhowerType.importantAndUrgent;
      default:
        return EisenhowerType.notImportantNotUrgent;
    }
  }

  // EisenhowerType을 eisenhower 값으로 매핑
  int _mapTypeToEisenhower(EisenhowerType type) {
    switch (type) {
      case EisenhowerType.notImportantNotUrgent:
        return 0;
      case EisenhowerType.urgentNotImportant:
        return 1;
      case EisenhowerType.importantNotUrgent:
        return 2;
      case EisenhowerType.importantAndUrgent:
        return 3;
    }
  }

  // EisenhowerType 설정
  void setEisenhowerType(EisenhowerType type) {
    _selectedEisenhowerType = type;
    notifyListeners();
  }

  void toggleShowOnHome(bool value) {
    showOnHome = value;
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
    // 현재 값 기준으로 initialDate 선정
    DateTime initialDate = DateTime.now();
    if (isStartDate && startDate != null) {
      initialDate = startDate!;
    } else if (!isStartDate && endDate != null) {
      initialDate = endDate!;
    }

    // 표시용 범위 전달(있다면 시작/끝/사이만 보여짐)
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (_) => SelectDateBottomSheet(
        initialDate: initialDate,
        rangeStart: startDate,
        rangeEnd: endDate,
      ),
    );

    if (picked == null) return;

    if (isStartDate) {
      startDate = picked;
      // 역전 방지: 기존 endDate가 start보다 앞이면 end를 start로 맞춤
      if (endDate != null && startDate!.isAfter(endDate!)) {
        endDate = startDate;
      }
    } else {
      endDate = picked;
      // 역전 방지: 기존 startDate가 end보다 뒤면 start를 end로 맞춤
      if (startDate != null && endDate!.isBefore(startDate!)) {
        startDate = endDate;
      }
    }

    notifyListeners();
  }


  Todo _buildTodo() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedStart = isDailyTodo ? today : (startDate ?? today);
    final normalizedEnd = isDailyTodo ? today : (endDate ?? today);

    // EisenhowerType을 eisenhower 값으로 변환
    return Todo(
      id: todo?.id ?? now.millisecondsSinceEpoch.toString(),
      title: title,
      startDate: normalizedStart,
      endDate: normalizedEnd,
      goalId: selectedGoalId,
      eisenhower: _mapTypeToEisenhower(_selectedEisenhowerType),
      showOnHome: showOnHome,
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
