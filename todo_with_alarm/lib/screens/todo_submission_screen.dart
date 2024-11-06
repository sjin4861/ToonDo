import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:intl/intl.dart';
import 'todo_input_screen.dart'; // TodoInputScreen 임포트

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
    todos = todoProvider.getAllTodos();

    // D-Day 투두와 Daily 투두 분류
    dDayTodos = todos.where((todo) {
      final duration = todo.endDate.difference(todo.startDate).inDays;
      return duration >= 1; // 2일 이상 지속되는 투두
    }).toList();

    dailyTodos = todos.where((todo) {
      final duration = todo.endDate.difference(todo.startDate).inDays;
      return duration == 0; // 하루짜리 투두
    }).toList();

    // 정렬
    dDayTodos.sort((a, b) => a.endDate.compareTo(b.endDate));
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
          _buildWeeklyCalendar(),
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

  Widget _buildWeeklyCalendar() {
    List<DateTime> weekDates = List.generate(7, (index) => currentWeekStartDate.add(Duration(days: index)));
    List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _goToPreviousWeek,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                DateTime date = weekDates[index];
                String dayLabel = weekDays[index];
                bool isSelected = dateFormat.format(date) == dateFormat.format(selectedDate);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                      // 선택된 날짜의 투두를 다시 로드
                      loadTodos();
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        dayLabel,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[400] : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _goToNextWeek,
          ),
        ],
      ),
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      currentWeekStartDate = currentWeekStartDate.subtract(Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      currentWeekStartDate = currentWeekStartDate.add(Duration(days: 7));
    });
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
                    return _buildTodoItem(todo);
                  },
                )
              : Text('투두가 없습니다.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return GestureDetector(
      onTap: () {
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
          // 투두 수정 후 돌아왔을 때 투두 리스트를 다시 로드
          setState(() {
            loadTodos();
          });
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Checkbox(
              value: todo.status >= 100,
              onChanged: (value) {
                setState(() {
                  todo.updateStatus(value! ? 100 : 0);
                });
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.status >= 100 ? TextDecoration.lineThrough : null,
                  color: _getImportanceColor(todo.importance),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Color _getImportanceColor(double importance) {
    if (importance >= 7) return Colors.red;
    if (importance >= 4) return Colors.orange;
    return Colors.green;
  }
}