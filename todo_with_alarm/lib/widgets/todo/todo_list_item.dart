// lib/widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_submission_viewmodel.dart';
import 'package:todo_with_alarm/views/todo/todo_input_screen.dart';
import 'package:todo_with_alarm/widgets/todo/todo_edit_bottom_sheet.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo, double) onStatusUpdate; // onUpdate를 수정하여 status와 함께 전달
  final Function() onDelete;
  final Function() onPostpone;
  final Function() onUpdate;
  final bool hideCompletionStatus;
  final DateTime selectedDate;

  const TodoListItem({
    Key? key,
    required this.todo,
    required this.selectedDate,
    required this.onUpdate,
    required this.onStatusUpdate,
    required this.onDelete,
    required this.onPostpone,
    this.hideCompletionStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDDay = todo.isDDayTodo();
    bool isCompleted = todo.status >= 100;

    // D-Day → 진행률 표시, Daily → Checkbox
    Widget trailingWidget = isDDay
        ? _buildProgressIndicator(context)
        : Checkbox(
            value: isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                onStatusUpdate(todo, value ? 100 : 0);
              }
            },
            activeColor: todo.getBorderColor(),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      // Figma 디자인처럼 키우고 싶다면 height도 지정 가능
      // height: 56,
      decoration: ShapeDecoration(
        color: isCompleted ? const Color(0xFFEEEEEE) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isCompleted
                ? const Color(0x7FDDDDDD)
                : todo.getBorderColor(),
          ),
          // ★ 둥글기 크게
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: _buildLeading(context),
        title: Text(
          todo.title,
          style: TextStyle(
            color: isCompleted ? const Color(0x4C111111) : const Color(0xFF1C1D1B),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.20,
            fontFamily: 'Pretendard Variable',
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: isDDay ? _buildDDaySubtitle() : _buildSubtitle(context),
        trailing: trailingWidget,
        onTap: () {
          _showTodoOptionsDialog(context, todo);
        },
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    // 목표 이름 가져오기
    String? goalName;
    if (todo.goalId != null) {
      final goalViewmodel = Provider.of<GoalViewModel>(context, listen: false);
      final matchingGoals = goalViewmodel.goals.where((goal) => goal.id == todo.goalId);
      if (matchingGoals.isNotEmpty) {
        goalName = matchingGoals.first.name;
      } else {
        // 목표를 찾지 못한 경우 처리
        goalName = '목표를 찾을 수 없음';
      }
    }

    if (goalName != null) {
      return Text(
        '목표: $goalName',
        style: const TextStyle(
          color: Color(0x7F1C1D1B),
          fontSize: 8,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.12,
          fontFamily: 'Pretendard Variable',
        ),
      );
    } else {
      return null;
    }
  }

  String _getDDayString() {
    DateTime today = selectedDate;
    int dDay = todo.endDate.difference(today).inDays;
    if (dDay > 0) {
      return 'D-$dDay';
    } else if (dDay == 0) {
      return 'D-Day';
    } else {
      return 'D+${-dDay}';
    }
  }

  /// D-Day 날짜/진행률용 subtitle
  Widget _buildDDaySubtitle() {
    return Row(
      children: [
        Text(
          '${DateFormat('yy.MM.dd').format(todo.startDate)} ~ ${DateFormat('yy.MM.dd').format(todo.endDate)}',
          style: const TextStyle(
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
          style: const TextStyle(
            color: Color(0x7F1C1D1B),
            fontSize: 8,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.12,
            fontFamily: 'Pretendard Variable',
          ),
        ),
      ],
    );
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
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF78B545)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${todo.status.toInt()}%',
            style: const TextStyle(
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
    // ToDoEditBottomSheet를 호출합니다.
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
            onUpdate();
          },
          onDelete: () {
            Navigator.pop(context);
            // 투두 삭제
            onDelete();
          },
          onPostpone: () {
            Navigator.pop(context);
            // 투두를 내일로 미룸
            onPostpone();
          },
          onStatusUpdate: (double newStatus) {
            onStatusUpdate(todo, newStatus);
          },
        );
      },
    );
  }
  /// leading 아이콘
  Widget _buildLeading(BuildContext context) {
    final goalViewmodel = Provider.of<GoalViewModel>(context, listen: false);
    final matchedGoal = goalViewmodel.goals
        .where((g) => g.id == todo.goalId)
        .isNotEmpty
        ? goalViewmodel.goals.firstWhere((g) => g.id == todo.goalId)
        : null;

    bool isCompleted = todo.status >= 100;
    final iconPath = matchedGoal?.icon; // goal.icon

    return _buildGoalIcon(iconPath, todo.getBorderColor(), isSelected: !isCompleted);
  }

  /// goal.icon (SVG) 표시
  Widget _buildGoalIcon(String? iconPath, Color borderColor, {bool isSelected = false}) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? borderColor.withOpacity(0.2)
            : const Color(0x7FDDDDDD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: iconPath != null
          ? SvgPicture.asset(
              iconPath,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.help_outline,
              size: 16,
              color: borderColor,
            ),
    );
  }
}