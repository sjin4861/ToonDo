import 'package:domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presentation/designsystem/components/items/app_todo_item.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/utils/get_todo_border_color.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:presentation/views/todo/input/todo_input_screen.dart';

class TodoListSection extends StatelessWidget {
  final String title;
  final List todos;
  final TodoManageViewModel viewModel;
  final bool isDDay;

  const TodoListSection({
    super.key,
    required this.title,
    required this.todos,
    required this.viewModel,
    required this.isDDay,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.todoMaxContentWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              key: const Key('addTodoButton'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TodoInputScreen(isDDayTodo: isDDay),
                  ),
                );
                viewModel.loadTodos();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                    side: const BorderSide(
                      width: 0.5,
                      color: Color(0x3F1C1D1B),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1D1B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.add_circle_outline,
                      size: 12,
                      color: Color(0xFF1C1D1B),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            todos.isNotEmpty
                ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final Goal? matchedGoal = viewModel.goals.firstWhere(
                      (g) => g.id == todo.goalId,
                  orElse: () => Goal.empty(),
                );

                final isCompleted = todo.status >= 100;
                final iconPath = matchedGoal!.icon;
                final levelColor = getBorderColor(todo);

                String? subtitle;
                if (isDDay) {
                  final dDay = todo.endDate.difference(viewModel.selectedDate).inDays;
                  final dDayStr = dDay > 0 ? 'D-$dDay' : (dDay == 0 ? 'D-Day' : 'D+${-dDay}');
                  subtitle =
                  '${DateFormat('yy.MM.dd').format(todo.startDate)} ~ ${DateFormat('yy.MM.dd').format(todo.endDate)} $dDayStr';
                } else if (todo.goalId != null) {
                  subtitle = null;
                }

                return AppTodoItem(
                  dismissKey: Key(todo.id.toString()),
                  title: todo.title,
                  iconPath: iconPath,
                  subTitle: subtitle,
                  isChecked: isCompleted,
                  levelColor: levelColor,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoInputScreen(
                          todo: todo,
                          isDDayTodo: isDDay,
                        ),
                      ),
                    );
                    viewModel.loadTodos();
                  },
                  onCheckedChanged: (value) {
                    viewModel.updateTodoStatus(todo, value ? 100 : 0);
                  },
                  onSwipeLeft: () => viewModel.deleteTodoById(todo.id),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spacing8),
            )
                : const Center(
              child: Text(
                '투두가 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
