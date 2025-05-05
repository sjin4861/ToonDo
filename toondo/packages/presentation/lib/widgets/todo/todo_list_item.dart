// lib/widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/goal.dart';
import 'package:intl/intl.dart';
import 'todo_edit_bottom_sheet.dart';
import 'package:presentation/utils/get_todo_border_color.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final List<Goal> goals;
  final Function(Todo, double) onStatusUpdate; // onUpdate를 수정하여 status와 함께 전달
  final Function() onDelete;
  final Function() onPostpone;
  final Function() onUpdate;
  final bool hideCompletionStatus;
  final DateTime selectedDate;

  const TodoListItem({
    Key? key,
    required this.todo,
    required this.goals,
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
            activeColor: getBorderColor(todo),
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
                : getBorderColor(todo),
          ),
          // ★ 둥글기 크게
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      final matching = goals.where((g) => g.id == todo.goalId);
      goalName = matching.isNotEmpty ? matching.first.name : '목표를 찾을 수 없음';
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
          goals: goals,
          onUpdate: () {
            Navigator.pop(context);
            onUpdate();
          },
          onDelete: () {
            Navigator.pop(context);
            onDelete();
          },
          onPostpone: () {
            Navigator.pop(context);
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
    final matched = goals.where((g) => g.id == todo.goalId);
    final matchedGoal = matched.isNotEmpty ? matched.first : null;

    bool isCompleted = todo.status >= 100;
    final iconPath = matchedGoal?.icon; // goal.icon

    return _buildGoalIcon(iconPath, getBorderColor(todo), isSelected: !isCompleted);
  }

  /// goal.icon (SVG) 표시
  Widget _buildGoalIcon(String? iconPath, Color borderColor, {bool isSelected = false}) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? borderColor.withOpacity(0.2)
            : const Color(0x7FDDDDDD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: iconPath != null
          ? SvgPicture.asset(
              iconPath,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.help_outline,
              size: 20,
              color: borderColor,
            ),
    );
  }
}