import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/goal.dart';
import 'package:intl/intl.dart';
import 'package:presentation/utils/get_todo_border_color.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final List<Goal> goals;
  final Function(Todo, double) onStatusUpdate;
  final Function() onDelete;
  final Function() onPostpone;
  final Function() onUpdate;
  final bool hideCompletionStatus;
  final DateTime selectedDate;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.goals,
    required this.selectedDate,
    required this.onUpdate,
    required this.onStatusUpdate,
    required this.onDelete,
    required this.onPostpone,
    this.hideCompletionStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDDay = todo.isDDayTodo();
    bool isCompleted = todo.status >= 100;

    Widget trailingWidget =
        isDDay
            ? _buildProgressIndicator(context)
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 12,
                height: 12,
                child: Checkbox(
                  value: isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      onStatusUpdate(todo, value ? 100 : 0);
                    }
                  },
                  activeColor: getBorderColor(todo),
                  checkColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // 터치 영역 축소
                  visualDensity: VisualDensity.compact,
                  // 여백 최소화
                  side: const BorderSide(
                    color: Color(0x801C1D1B), // 투명도 50% 적용된 테두리 색
                    width: 1.5,
                  ),
                ),
              ),
            );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onUpdate,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFEEEEEE) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCompleted ? const Color(0x7FDDDDDD) : getBorderColor(todo),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeading(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        color:
                            isCompleted
                                ? const Color(0x4C111111)
                                : const Color(0xFF1C1D1B),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.15,
                        fontFamily: 'Pretendard Variable',
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    isDDay
                        ? _buildDDaySubtitle()
                        : _buildSubtitle(context) ?? const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(height: 36, child: Center(child: trailingWidget)),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
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
    if (dDay > 0) return 'D-$dDay';
    if (dDay == 0) return 'D-Day';
    return 'D+${-dDay}';
  }

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

  Widget _buildProgressIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
          child: LinearProgressIndicator(
            value: todo.status / 100,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF78B545)),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${todo.status.toInt()}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1D1B),
          ),
        ),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    final matched = goals.where((g) => g.id == todo.goalId);
    final matchedGoal = matched.isNotEmpty ? matched.first : null;

    bool isCompleted = todo.status >= 100;
    final iconPath = matchedGoal?.icon;

    return _buildGoalIcon(
      iconPath,
      getBorderColor(todo),
      isSelected: !isCompleted,
    );
  }

  Widget _buildGoalIcon(
    String? iconPath,
    Color borderColor, {
    bool isSelected = false,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? borderColor : const Color(0xFFDDDDDD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child:
            iconPath != null
                ? SvgPicture.asset(
                  iconPath,
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                )
                : Icon(Icons.help_outline, size: 16, color: Color(0xff1C1D1B)),
      ),
    );
  }
}
