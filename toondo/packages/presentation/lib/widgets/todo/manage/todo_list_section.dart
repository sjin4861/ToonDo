import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:presentation/views/todo/todo_input_screen.dart';
import 'package:presentation/widgets/todo/common/todo_list_item.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
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
                  side: const BorderSide(width: 0.5, color: Color(0x3F1C1D1B)),
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
                  const Icon(Icons.add_circle_outline, size: 12, color: Color(0xFF1C1D1B)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        todos.isNotEmpty
            ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoListItem(
                      todo: todo,
                      goals: viewModel.goals,
                      selectedDate: DateTime(
                        viewModel.selectedDate.year,
                        viewModel.selectedDate.month,
                        viewModel.selectedDate.day,
                      ),
                      onUpdate: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => TodoInputScreen(
                                  todo: todo,
                                  isDDayTodo: isDDay,
                                ),
                          ),
                        );
                        viewModel.loadTodos();
                      },
                      onStatusUpdate:
                          (updated, newStatus) =>
                              viewModel.updateTodoStatus(updated, newStatus),
                      onDelete: () => viewModel.deleteTodoById(todo.id),
                      onPostpone: () {
                        final newStart = todo.startDate.add(
                          const Duration(days: 1),
                        );
                        final newEnd = todo.endDate.add(
                          const Duration(days: 1),
                        );
                        viewModel.updateTodoDates(todo, newStart, newEnd);
                      },
                      hideCompletionStatus: isDDay,
                    );
                  },
                ),
              ),
            )
            : const Center(
              child: Text('투두가 없습니다.', style: TextStyle(color: Colors.grey)),
            ),
      ],
    );
  }
}
