// lib/widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/views/todo/todo_submission_screen.dart'; // 필요한 경우 추가

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo, double) onStatusUpdate; // onUpdate를 수정하여 status와 함께 전달
  final Function() onDelete;
  final bool hideCompletionStatus;

  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onStatusUpdate,
    required this.onDelete,
    this.hideCompletionStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDDay = todo.isDDayTodo();
    bool isCompleted = todo.status >= 100;

    // 디데이 투두인 경우, 진행률 표시기를 trailing에 표시
    // 데일리 투두인 경우, 체크박스를 trailing에 표시
    Widget trailingWidget = isDDay
        ? _buildProgressIndicator(context)
        : Checkbox(
            value: isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                onStatusUpdate(todo, value ? 100 : 0);
              }
            },
            activeColor: Theme.of(context).primaryColor,
          );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: ShapeDecoration(
        color: isCompleted ? Color(0xFFEEEEEE) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: isCompleted ? 1 : 1.5,
            color: isCompleted ? Color(0x7FDDDDDD) : todo.getBorderColor(),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        leading: _buildLeading(context, isDDay),
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
                    _getDDayString(),
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
            : _buildSubtitle(context),
        trailing: trailingWidget,
        onTap: () {
          _showTodoOptionsDialog(context, todo);
        },
      ),
    );
  }

  Widget _buildLeading(BuildContext context, bool isDDay) {
    // 진행률 표시 위젯
    Widget progressIndicator = hideCompletionStatus
        ? SizedBox.shrink()
        : SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: todo.status / 100,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                Center(
                  child: Text(
                    '${todo.status.toInt()}%',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );

    return progressIndicator;
  }

  Widget? _buildSubtitle(BuildContext context) {
    // 목표 이름 가져오기
    String? goalName;
    if (todo.goalId != null) {
      final goalViewmodel = Provider.of<GoalViewModel>(context, listen: false);
      final matchingGoals =
          goalViewmodel.goals.where((goal) => goal.id == todo.goalId);
      if (matchingGoals.isNotEmpty) {
        goalName = matchingGoals.first.name;
      } else {
        // 목표를 찾지 못한 경우 처리
        goalName = '목표를 찾을 수 없음';
      }
    }

    if (goalName != null) {
      return Text('목표: $goalName');
    } else {
      return null;
    }
  }

  String _getDDayString() {
    DateTime today = DateTime.now();
    int dDay = todo.endDate.difference(today).inDays;
    if (dDay > 0) {
      return 'D-$dDay';
    } else if (dDay == 0) {
      return 'D-Day';
    } else {
      return 'D+${-dDay}';
    }
  }

  // 진행률 표시기 위젯 (디데이 투두용)
  Widget _buildProgressIndicator(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: todo.status / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78B545)),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${todo.status.toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1D1B),
            ),
          ),
        ],
      ),
    );
  }

  void _showTodoOptionsDialog(BuildContext context, Todo todo) {
    // ToDoEditBottomSheet는 여기서 사용되지 않습니다.
    // 대신, ListTile의 onTap에서 직접 상태 업데이트를 처리합니다.
  }
}