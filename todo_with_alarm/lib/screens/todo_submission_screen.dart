import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:intl/intl.dart';
import 'todo_input_screen.dart'; // TodoInputScreen 임포트
import 'package:todo_with_alarm/widgets/Calendar.dart'; // Calendar 위젯 임포트
import 'package:todo_with_alarm/widgets/todo_edit_bottom_sheet.dart'; // ToDoEditBottomSheet 임포트
import 'package:todo_with_alarm/services/todo_service.dart'; // TodoService 임포트

enum FilterOption { all, goal, importance }
class TodoSubmissionScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const TodoSubmissionScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  _TodoSubmissionScreenState createState() => _TodoSubmissionScreenState();
}

class _TodoSubmissionScreenState extends State<TodoSubmissionScreen> {
  late DateTime selectedDate;
  late DateTime currentWeekStartDate;
  String? selectedGoalId;
  FilterOption selectedFilter = FilterOption.all;
  List<Todo> todos = [];
  List<Todo> dDayTodos = [];
  List<Todo> dailyTodos = [];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();
    currentWeekStartDate = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    loadTodos();
  }

  void loadTodos() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    // 모든 투두 가져오기
    List<Todo> allTodos = todoProvider.getAllTodos();
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // 선택된 날짜에 해당하는 투두 필터링
    List<Todo> todosForSelectedDate = allTodos.where((todo) {
      DateTime todoStartDate =
          DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) ||
              todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todoEndDate.isAfter(selectedDateOnly) ||
              todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();

    // 선택된 필터에 따라 추가 필터링 적용
    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      todosForSelectedDate = todosForSelectedDate
          .where((todo) => todo.goalId == selectedGoalId)
          .toList();
    } else if (selectedFilter == FilterOption.importance) {
      todosForSelectedDate = todosForSelectedDate
          .where((todo) => todo.importance == 1) // 중요도가 3 이상인 투두 필터링
          .toList();
    }

    // D-Day 투두와 데일리 투두 분류
    dDayTodos = todosForSelectedDate.where((todo) {
      DateTime todoStartDate =
          DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final duration = todoEndDate.difference(todoStartDate).inDays;
      return duration >= 1; // D-Day 투두
    }).toList();

    dailyTodos = todosForSelectedDate.where((todo) {
      DateTime todoStartDate =
          DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final duration = todoEndDate.difference(todoStartDate).inDays;
      return duration == 0; // 데일리 투두
    }).toList();

    // D-Day 투두 정렬 (D-Day 값 기준)
    dDayTodos.sort((a, b) {
      DateTime aEndDate = DateTime(a.endDate.year, a.endDate.month, a.endDate.day);
      DateTime bEndDate = DateTime(b.endDate.year, b.endDate.month, b.endDate.day);
      int aDDay = aEndDate.difference(selectedDateOnly).inDays;
      int bDDay = bEndDate.difference(selectedDateOnly).inDays;
      return aDDay.compareTo(bDDay);
    });

    // 데일리 투두 정렬 (중요도 기준)
    dailyTodos.sort((a, b) => b.importance.compareTo(a.importance));
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    List<Goal> goals = goalProvider.goals;

    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경색 설정
      appBar: AppBar(
        backgroundColor: Color(0xFFFCFCFC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
          onPressed: () {
            Navigator.pop(context); // 메인 페이지로 돌아가기
          },
        ),
        title: Text(
          '투두리스트',
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.24,
            fontFamily: 'Pretendard Variable',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(
            color: Color(0x3F1C1D1B),
            height: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // 캘린더 위젯
          Calendar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                loadTodos();
              });
            },
          ),
          // 목표 메뉴 바
          const SizedBox(height: 16),

          _buildGoalMenuBar(),

          // 만약 "목표" 탭이 선택되었을 경우 목표 선택 바 표시
          if (selectedFilter == FilterOption.goal)
            _buildGoalSelectionBar(goals),

          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                // 모든 투두 가져오기
                List<Todo> allTodos = todoProvider.getAllTodos();

                // 선택된 날짜에 해당하는 투두 필터링
                List<Todo> todosForSelectedDate = _filterTodosByDate(allTodos);

                // 선택된 필터에 따라 추가 필터링 적용
                todosForSelectedDate = _applyFilter(todosForSelectedDate);

                // D-Day 투두와 데일리 투두 분류 및 정렬
                _categorizeAndSortTodos(todosForSelectedDate);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTodoSection('디데이 투두', dDayTodos, isDDay: true),
                      _buildTodoSection('데일리 투두', dailyTodos, isDDay: false),
                    ],
                  ),
                );
              },
            ),
          ),
          // 탭 바 자리
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: Color(0xFFFCFCFC),
              border: Border(
                top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
              ),
            ),
            // 필요한 위젯 추가
          ),
        ],
      ),
    );
  }

  Widget _buildGoalMenuBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFE4F0D9)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          _buildFilterButton(
            label: '전체',
            isSelected: selectedFilter == FilterOption.all,
            onTap: () {
              setState(() {
                selectedFilter = FilterOption.all;
                selectedGoalId = null;
                loadTodos();
              });
            },
          ),
          _buildFilterButton(
            label: '목표',
            isSelected: selectedFilter == FilterOption.goal,
            onTap: () {
              setState(() {
                selectedFilter = FilterOption.goal;
                selectedGoalId = null; // 목표 선택 초기화
                loadTodos();
              });
            },
          ),
          _buildFilterButton(
            label: '중요',
            isSelected: selectedFilter == FilterOption.importance,
            onTap: () {
              setState(() {
                selectedFilter = FilterOption.importance;
                selectedGoalId = null;
                loadTodos();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: ShapeDecoration(
            color: isSelected ? Color(0xFF78B545) : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: label == '전체' ? Radius.circular(8) : Radius.zero,
                bottomLeft: label == '전체' ? Radius.circular(8) : Radius.zero,
                topRight: label == '중요' ? Radius.circular(8) : Radius.zero,
                bottomRight: label == '중요' ? Radius.circular(8) : Radius.zero,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.21,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalSelectionBar(List<Goal> goals) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (context, index) {
          Goal goal = goals[index];
          bool isSelected = selectedGoalId == goal.id;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGoalId = goal.id;
                loadTodos();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF78B545) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFE4F0D9)),
              ),
              child: Center(
                child: Text(
                  goal.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 0.21,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 24),
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: ShapeDecoration(
          color: isSelected ? Color(0xFF78B545) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
              ? BorderSide.none
              : BorderSide(color: Color(0xFFE4F0D9)),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              letterSpacing: 0.21,
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoSection(String title, List<Todo> todos, {required bool isDDay}) {
    // 선택된 Goal에 따라 필터링
    List<Todo> filteredTodos = selectedGoalId == null
        ? todos
        : todos.where((todo) => todo.goalId == selectedGoalId).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더
          GestureDetector(
            onTap: () {
              // 투두 추가 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoInputScreen(
                    isDDayTodo: isDDay,
                  ),
                ),
              ).then((_) {
                setState(() {
                  loadTodos();
                });
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5, color: Color(0x3F1C1D1B)),
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.17,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.add, size: 12, color: Color(0xFF1C1D1B)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 투두 리스트
          filteredTodos.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    Todo todo = filteredTodos[index];
                    return _buildTodoItem(todo, isDDay: isDDay);
                  },
                )
              : Text('투두가 없습니다.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodoItem(Todo todo, {required bool isDDay}) {
    // 날짜 계산 및 기타 변수 설정
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    int dDay = todo.endDate.difference(selectedDateOnly).inDays;
    String dDayString = dDay > 0 ? 'D-$dDay' : dDay == 0 ? 'D-Day' : 'D+${-dDay}';
    
    int importance = todo.importance;
    int urgency = todo.urgency;
    Color borderColor = _getBorderColor(importance, urgency);
    bool isCompleted = todo.status >= 100;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: ShapeDecoration(
        color: isCompleted ? Color(0xFFEEEEEE) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: isCompleted ? 1 : 1.5,
            color: isCompleted ? Color(0x7FDDDDDD) : borderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        leading: Container(
          width: 24,
          height: 24,
          padding: EdgeInsets.all(4),
          decoration: ShapeDecoration(
            color: borderColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            _getGoalIcon(todo.goalId),
            size: 16,
            color: Colors.white,
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            color: isCompleted ? Color(0x4C111111) : Color(0xFF1C1D1B),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.20,
            fontFamily: 'Pretendard Variable',
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: isDDay
            ? Row(
                children: [
                  Text(
                    '${DateFormat('yy.MM.dd').format(todo.startDate)} ~ ${DateFormat('yy.MM.dd').format(todo.endDate)}',
                    style: TextStyle(
                      color: Color(0x7F1C1D1B),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.12,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dDayString,
                    style: TextStyle(
                      color: Color(0x7F1C1D1B),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.12,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                ],
              )
            : null,
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (bool? value) {
            setState(() {
              todo.status = value! ? 100 : 0;
              Provider.of<TodoProvider>(context, listen: false).updateTodoStatus(todo.id, todo.status);
              loadTodos();
            });
          },
          activeColor: borderColor,
        ),
        onTap: () {
          _showTodoOptionsDialog(todo);
        },
      ),
    );
  }

  Color _getBorderColor(int importance, int urgency) {
    if (importance == 1 && urgency == 1) {
      return Colors.red; // 중요도 1, 긴급도 1
    } else if (importance == 1 && urgency == 0) {
      return Colors.blue; // 중요도 1, 긴급도 0
    } else if (importance == 0 && urgency == 1) {
      return Colors.yellow; // 중요도 0, 긴급도 1
    } else {
      return Colors.black; // 중요도 0, 긴급도 0
    }
  }
  // 목표 아이콘 반환 메서드 (임시 코드임)
  IconData _getGoalIcon(String? goalId) {
    switch (goalId) {
      case 'goal1':
        return Icons.school;
      case 'goal2':
        return Icons.work;
      case 'goal3':
        return Icons.fitness_center;
      default:
        return Icons.flag;
    }
  }

  void _showTodoOptionsDialog(Todo todo) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return ToDoEditBottomSheet(
          todo: todo,
          onUpdate: () {
            Navigator.pop(context);
            // 투두 수정 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoInputScreen(
                  isDDayTodo: todo.endDate.difference(todo.startDate).inDays >= 1,
                  todo: todo,
                ),
              ),
            ).then((_) {
              setState(() {
                loadTodos();
              });
            });
          },
          onDelete: () {
            Navigator.pop(context);
            // 투두 삭제
            Provider.of<TodoProvider>(context, listen: false).deleteTodoById(todo.id);
            setState(() {
              loadTodos();
            });
          },
          onPostpone: () {
            Navigator.pop(context);
            // 투두를 내일로 미룸
            setState(() {
              todo.startDate = todo.startDate.add(Duration(days: 1));
              todo.endDate = todo.endDate.add(Duration(days: 1));
              loadTodos();
            });
          },
        );
      },
    );
  }
    
  List<Todo> _filterTodosByDate(List<Todo> allTodos) {
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    return allTodos.where((todo) {
      DateTime todoStartDate = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) ||
              todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todoEndDate.isAfter(selectedDateOnly) ||
              todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();
  }

  List<Todo> _applyFilter(List<Todo> todos) {
    if (selectedFilter == FilterOption.goal && selectedGoalId != null) {
      return todos.where((todo) => todo.goalId == selectedGoalId).toList();
    } else if (selectedFilter == FilterOption.importance) {
      return todos.where((todo) => todo.importance >= 3).toList();
    } else {
      return todos;
    }
  }

  void _categorizeAndSortTodos(List<Todo> todosForSelectedDate) {
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // D-Day 투두와 데일리 투두 분류
    dDayTodos = todosForSelectedDate.where((todo) {
      DateTime todoStartDate = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final duration = todoEndDate.difference(todoStartDate).inDays;
      return duration >= 1; // D-Day 투두
    }).toList();

    dailyTodos = todosForSelectedDate.where((todo) {
      DateTime todoStartDate = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
      final duration = todoEndDate.difference(todoStartDate).inDays;
      return duration == 0; // 데일리 투두
    }).toList();

    // D-Day 투두 정렬 (D-Day 값 기준)
    dDayTodos.sort((a, b) {
      DateTime aEndDate = DateTime(a.endDate.year, a.endDate.month, a.endDate.day);
      DateTime bEndDate = DateTime(b.endDate.year, b.endDate.month, b.endDate.day);
      int aDDay = aEndDate.difference(selectedDateOnly).inDays;
      int bDDay = bEndDate.difference(selectedDateOnly).inDays;
      return aDDay.compareTo(bDDay);
    });

    // 데일리 투두 정렬 (중요도 기준)
    dailyTodos.sort((a, b) => b.importance.compareTo(a.importance));
  }

}