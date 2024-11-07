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
      DateTime todoStartDate =
          DateTime(todo.startDate.year, todo.startDate.month, todo.startDate.day);
      DateTime todoEndDate = DateTime(todo.endDate.year, todo.endDate.month, todo.endDate.day);

      return (todoStartDate.isBefore(selectedDateOnly) ||
              todoStartDate.isAtSameMomentAs(selectedDateOnly)) &&
          (todoEndDate.isAfter(selectedDateOnly) ||
              todoEndDate.isAtSameMomentAs(selectedDateOnly));
    }).toList();

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
        backgroundColor: Color(0xFFF1F1F1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF535353)),
          onPressed: () {
            Navigator.pop(context); // 메인 페이지로 돌아가기
          },
        ),
        title: Text(
          '투두리스트',
          style: TextStyle(
            color: Color(0xFF535353),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.24,
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
          // 월 표시
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              '${selectedDate.month}월',
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.24,
              ),
            ),
          ),
          // 목표 메뉴 바
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
          // 탭 바 자리
          Container(
            height: 64,
            color: Color(0xFFDAEBCB),
            // 필요한 위젯 추가
          ),
        ],
      ),
    );
  }

  Widget _buildGoalMenuBar(List<Goal> goals) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 28),
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
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF78B545) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? null : Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.21,
              ),
            ),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      // 섹션별 배경색 설정 (필요에 따라 조정)
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.21,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
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

    // 완료된 투두인지 여부
    bool isCompleted = todo.status >= 100;

    return GestureDetector(
      onTap: () {
        _showTodoOptionsDialog(todo);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: isCompleted ? Color(0x3FF1F1F1) : Color(0xFFF1F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isCompleted
                ? BorderSide(width: 1, color: Color(0x7F111111))
                : BorderSide.none,
          ),
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
                        color: isCompleted ? Color(0x4C111111) : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
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
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.12,
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
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.12,
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
              value: isCompleted,
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