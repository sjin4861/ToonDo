import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/todo_edit_bottom_sheet.dart';
import 'package:presentation/designsystem/components/items/app_todo_item.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/utils/get_todo_border_color.dart';
import 'package:presentation/utils/routine_subtitle.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:presentation/views/todo/input/todo_input_screen.dart';

class TodoListSection extends StatelessWidget {
  final String title;
  final List todos;
  final TodoManageViewModel viewModel;
  final bool isDDay;
  final bool isRoutine;

  const TodoListSection({
    super.key,
    required this.title,
    required this.todos,
    required this.viewModel,
    required this.isDDay,
    this.isRoutine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
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
                    builder: (_) => TodoInputScreen(
                      isDDayTodo: isDDay,
                      isRoutine: isRoutine,
                    ),
                  ),
                );
                viewModel.loadTodos();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h8,
                  vertical: AppSpacing.v6,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                    side: const BorderSide(
                      width: 0.5,
                      color: AppColors.status100_25,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body3SemiBold.copyWith(
                        color: AppColors.status100,
                      ),
                    ),
                    SizedBox(width: AppSpacing.h4),
                    Icon(
                      Icons.add_circle_outline,
                      size: AppDimensions.iconSize12,
                      color: AppColors.status100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.v14),
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

                    // status 값이 0.0(진행)/1.0(완료) 기준으로 변경됨
                    final isCompleted = todo.status >= 1.0;
                    final iconPath = matchedGoal!.icon;
                    final levelColor = getBorderColor(todo);

                    String? subtitle;
                    if (isRoutine) {
                      subtitle = _routineSubtitle(todo, viewModel.selectedDate);
                    } else if (isDDay) {
                      final end = DateTime(
                        todo.endDate.year,
                        todo.endDate.month,
                        todo.endDate.day,
                      );
                      final base = DateTime(
                        viewModel.selectedDate.year,
                        viewModel.selectedDate.month,
                        viewModel.selectedDate.day,
                      );
                      final dDay = end.difference(base).inDays;
                      final dDayStr =
                          dDay > 0
                              ? 'D-$dDay'
                              : (dDay == 0 ? 'D-Day' : 'D+${-dDay}');
                      subtitle =
                          '${DateFormat('yy.MM.dd').format(todo.startDate)} ~ ${DateFormat('yy.MM.dd').format(todo.endDate)} $dDayStr';
                    } else if (todo.goalId != null) {
                      subtitle = null;
                    }

                    return AppTodoItem(
                      title: todo.title,
                      iconPath: iconPath,
                      subTitle: subtitle,
                      isDdayTodo: isDDay,
                      isChecked: isCompleted,
                      levelColor: levelColor,
                      onDelete: () =>
                          _handleDelete(context, todo, viewModel),
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (context) => TodoEditBottomSheet(
                                title: todo.title,
                                iconPath: matchedGoal.icon!,
                                iconBgColor: getBorderColor(todo),
                                isDaily: !isDDay,
                                onEdit: () async {
                                  Navigator.pop(context); // 먼저 바텀시트 닫기
                                  // 루틴은 occurrence가 아닌 series 템플릿을 편집해야 함
                                  final editTarget = isRoutine
                                      ? viewModel.routineSeries.firstWhere(
                                          (s) => s.id == todo.seriesId,
                                          orElse: () => todo,
                                        )
                                      : todo;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => TodoInputScreen(
                                            todo: editTarget,
                                            isDDayTodo: isDDay,
                                            isRoutine: isRoutine,
                                          ),
                                    ),
                                  );
                                  viewModel.loadTodos();
                                },
                                onDelete: () {
                                  Navigator.pop(context); // 바텀시트 닫기
                                  _handleDelete(context, todo, viewModel);
                                },
                                onDelay:
                                    isDDay
                                        ? null
                                        : () {
                                          viewModel.delayTodoToTomorrow(todo);
                                          Navigator.pop(context);
                                        },
                              ),
                        );
                      },
                      onCheckedChanged: (value) {
                        viewModel.updateTodoStatus(todo, value ? 100 : 0);
                      },
                      //onSwipeLeft: () => viewModel.deleteTodoById(todo.id),
                    );
                  },
                  separatorBuilder:
                      (_, __) => SizedBox(height: AppSpacing.v8),
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

  String? _routineSubtitle(Todo todo, DateTime selectedDate) {
    final series = viewModel.routineSeries.firstWhere(
      (s) => s.id == todo.seriesId,
      orElse: () => todo,
    );
    return routineSubtitle(
      occurrence: todo,
      selectedDate: selectedDate,
      series: series,
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    Todo todo,
    TodoManageViewModel viewModel,
  ) async {
    if (!todo.isRecurring) {
      viewModel.deleteTodoById(todo.id);
      return;
    }
    final seriesId = todo.seriesId ?? todo.id;
    await viewModel.deleteRecurringSeries(seriesId);
  }
}
