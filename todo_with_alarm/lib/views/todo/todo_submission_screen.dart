// lib/views/todo/todo_submission_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_submission_viewmodel.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_viewmodel.dart';
import 'package:intl/intl.dart';
import 'todo_input_screen.dart'; // TodoInputScreen 임포트
import 'package:todo_with_alarm/widgets/Calendar.dart'; // Calendar 위젯 임포트
import 'package:todo_with_alarm/widgets/todo_edit_bottom_sheet.dart'; // ToDoEditBottomSheet 임포트
import 'package:todo_with_alarm/widgets/todo_list_item.dart'; // TodoListItem 임포트


class TodoSubmissionScreen extends StatelessWidget {
  final DateTime? selectedDate;

  const TodoSubmissionScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TodoService 인스턴스를 Provider로부터 가져옵니다.
    final TodoService todoService = Provider.of<TodoService>(context, listen: false);

    return ChangeNotifierProvider<TodoSubmissionViewModel>(
      create: (_) => TodoSubmissionViewModel(
        todoService: todoService,
        initialDate: selectedDate,
      )..loadTodos(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFCFCFC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
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
        body: Consumer<TodoSubmissionViewModel>(
          builder: (context, viewModel, child) {
            final goalViewmodel = Provider.of<GoalViewModel>(context);
            List<Goal> goals = goalViewmodel.goals;

            return Column(
              children: [
                // 캘린더 위젯
                Calendar(
                  selectedDate: viewModel.selectedDate,
                  onDateSelected: (date) {
                    viewModel.updateSelectedDate(date);
                  },
                ),
                const SizedBox(height: 16),
                // 목표 메뉴 바
                _buildGoalMenuBar(viewModel),
                // 목표 선택 바
                if (viewModel.selectedFilter == FilterOption.goal)
                  _buildGoalSelectionBar(viewModel, goals),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTodoSection(context, '디데이 투두', viewModel.dDayTodos, viewModel, isDDay: true),
                        _buildTodoSection(context, '데일리 투두', viewModel.dailyTodos, viewModel, isDDay: false),
                      ],
                    ),
                  ),
                ),
                // 탭 바 자리
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCFCFC),
                    border: Border(
                      top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
                    ),
                  ),
                  // 필요한 위젯 추가
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoalMenuBar(TodoSubmissionViewModel viewModel) {
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
            isSelected: viewModel.selectedFilter == FilterOption.all,
            onTap: () {
              viewModel.updateSelectedFilter(FilterOption.all);
            },
          ),
          _buildFilterButton(
            label: '목표',
            isSelected: viewModel.selectedFilter == FilterOption.goal,
            onTap: () {
              viewModel.updateSelectedFilter(FilterOption.goal);
            },
          ),
          _buildFilterButton(
            label: '중요',
            isSelected: viewModel.selectedFilter == FilterOption.importance,
            onTap: () {
              viewModel.updateSelectedFilter(FilterOption.importance);
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

  Widget _buildGoalSelectionBar(TodoSubmissionViewModel viewModel, List<Goal> goals) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (context, index) {
          Goal goal = goals[index];
          bool isSelected = viewModel.selectedGoalId == goal.id;
          return GestureDetector(
            onTap: () {
              viewModel.updateSelectedFilter(FilterOption.goal, goalId: goal.id);
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

  Widget _buildTodoSection(
    BuildContext context,
    String title,
    List<Todo> todos,
    TodoSubmissionViewModel viewModel, {
    required bool isDDay,
  }) {
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
                viewModel.loadTodos();
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
          todos.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    Todo todo = todos[index];
                    return _buildTodoItem(context, todo, viewModel, isDDay: isDDay);
                  },
                )
              : Text('투두가 없습니다.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodoItem(
    BuildContext context,
    Todo todo,
    TodoSubmissionViewModel viewModel, {
    required bool isDDay,
  }) {
    DateTime selectedDateOnly = DateTime(
      viewModel.selectedDate.year,
      viewModel.selectedDate.month,
      viewModel.selectedDate.day,
    );
    int dDay = todo.endDate.difference(selectedDateOnly).inDays;
    String dDayString = dDay > 0 ? 'D-$dDay' : dDay == 0 ? 'D-Day' : 'D+${-dDay}';

    int importance = todo.importance;
    int urgency = todo.urgency;
    Color borderColor = todo.getBorderColor();
    bool isCompleted = todo.status >= 100;

    return TodoListItem(
      todo: todo,
      onStatusUpdate: (Todo updatedTodo, double newStatus) {
        viewModel.updateTodoStatus(updatedTodo, newStatus);
      },
      onDelete: () => viewModel.deleteTodoById(todo.id),
      hideCompletionStatus: isDDay, // D-Day 투두에서는 진행률을 숨기지 않음
    );
  }

  // 목표 아이콘 반환 메서드 (임시 코드)
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

  void _showTodoOptionsDialog(
    BuildContext context,
    Todo todo,
    TodoSubmissionViewModel viewModel,
  ) {
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
                  isDDayTodo: todo.isDDayTodo(),
                  todo: todo,
                ),
              ),
            ).then((_) {
              viewModel.loadTodos();
            });
          },
          onDelete: () {
            Navigator.pop(context);
            // 투두 삭제
            viewModel.deleteTodoById(todo.id);
          },
          onPostpone: () {
            Navigator.pop(context);
            // 투두를 내일로 미룸
            DateTime newStartDate = todo.startDate.add(Duration(days: 1));
            DateTime newEndDate = todo.endDate.add(Duration(days: 1));
            viewModel.updateTodoDates(todo, newStartDate, newEndDate);
          },
          onStatusUpdate: (double newStatus) {
            viewModel.updateTodoStatus(todo, newStatus);
          },
        );
      },
    );
  }
}