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
      DateTime todoStartDate = DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) || todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
            (todoEndDate.isAfter(selectedDateOnly) || todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();

    
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
  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    List<Goal> goals = goalProvider.goals;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 메인 페이지로 돌아가기
          },
        ),
        title: Text('투두리스트'),
      ),
      body: Column(
        children: [
          Calendar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                loadTodos();
              });
            },
          ),
          _buildGoalMenuBar(goals),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTodoSection('디데이 투두', dDayTodos, isDDay: true),
                  _buildTodoSection('데일리 투두', dailyTodos, isDDay: false),
                ],
              ),
            ),
          ),
          // Tab Bar는 모든 페이지 완성 후 추가 예정
        ],
      ),
    );
  }

  Widget _buildGoalMenuBar(List<Goal> goals) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "전체" 버튼
            bool isSelected = selectedGoalId == null;
            return _buildGoalButton(
              label: '전체',
              icon: Icons.all_inclusive,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedGoalId = null;
                  loadTodos();
                });
              },
            );
          } else {
            Goal goal = goals[index - 1];
            bool isSelected = selectedGoalId == goal.id;
            return _buildGoalButton(
              label: goal.name,
              icon: Icons.flag,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedGoalId = goal.id;
                  loadTodos();
                });
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildGoalButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[400] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16),
            SizedBox(width: isSelected ? 8 : 0),
            isSelected
                ? Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : SizedBox.shrink(),
          ],
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
      padding: EdgeInsets.all(16),
      color: Colors.grey[400],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // 투두 추가 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoInputScreen(isDDayTodo: isDDay),
                    ),
                  ).then((_) {
                    // 투두 추가 후 돌아왔을 때 투두 리스트를 다시 로드
                    setState(() {
                      loadTodos();
                    });
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
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
    // 날짜만 비교하기 위해 시간 정보 제거
    DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);
    DateTime selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // D-Day 계산
    int dDay = todo.endDate.difference(selectedDateOnly).inDays;

    // D-Day 문자열 포맷팅
    String dDayString;
    if (dDay > 0) {
      dDayString = 'D-$dDay';
    } else if (dDay == 0) {
      dDayString = 'D-Day';
    } else {
      dDayString = 'D+${-dDay}';
    }

    // 중요도에 따른 색상 설정
    Color importanceColor = _getImportanceColor(todo.importance);

    // 목표 아이콘 설정
    IconData goalIcon = _getGoalIcon(todo.goalId);

    return GestureDetector(
      onTap: () {
        _showTodoOptionsDialog(todo);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Color(0xFFF1F1F1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 좌측: 목표 아이콘 및 투두 정보
            Row(
              children: [
                // 목표 아이콘 및 중요도 색상 표시
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: importanceColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    goalIcon,
                    size: 16,
                    color: importanceColor,
                  ),
                ),
                const SizedBox(width: 12),
                // 투두 제목 및 D-Day 정보
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.18,
                        decoration: todo.status >= 100 ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isDDay)
                      Row(
                        children: [
                          Text(
                            '${DateFormat('yy.MM.dd').format(todo.startDate)} ~ ${DateFormat('yy.MM.dd').format(todo.endDate)}',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 2,
                            height: 2,
                            decoration: ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dDayString,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            // 우측: 체크박스
            Checkbox(
              value: todo.status >= 100,
              onChanged: (value) {
                setState(() {
                  todo.updateStatus(value! ? 100 : 0);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // 중요도에 따른 색상 반환 메서드
  Color _getImportanceColor(double importance) {
    if (importance >= 3) return Colors.red; // 중요도 3
    if (importance >= 2) return Colors.orange; // 중요도 2
    if (importance >= 1) return Colors.green; // 중요도 1
    return Colors.grey; // 중요도 미설정
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
}
