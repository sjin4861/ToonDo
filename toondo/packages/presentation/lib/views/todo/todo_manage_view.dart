import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/lib/models/goal.dart';
import 'package:toondo/data/models/todo.dart';
import '../../../../data/lib/repositories/todo_repository.dart';
import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/top_menu_bar/menu_bar.dart';
import '../../widgets/calendar/calendar.dart';
import '../../widgets/todo/todo_list_item.dart';
import 'todo_input_view.dart'; // 필요 시 경로 조정
import '../../viewmodels/todo/todo_manage_viewmodel.dart';

class TodoManageView extends StatelessWidget {
  final DateTime? selectedDate;
  const TodoManageView({Key? key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    return ChangeNotifierProvider<TodoManageViewModel>(
      create: (_) => TodoManageViewModel(
        todoRepository: todoRepository,
        initialDate: selectedDate,
      )..loadTodos(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: '투두리스트',
        ),
        body: Consumer<TodoManageViewModel>(
          builder: (context, viewModel, child) {
            final goalViewModel = Provider.of<GoalViewModel>(context);
            final goals = goalViewModel.goals;

            return Column(
              children: [
                // 캘린더
                Calendar(
                  selectedDate: viewModel.selectedDate,
                  onDateSelected: (date) => viewModel.updateSelectedDate(date),
                ),
                const SizedBox(height: 16),
                // 메뉴 바
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: MenuBarWidget(
                    selectedMenu: _filterOptionToMenuOption(viewModel.selectedFilter),
                    onItemSelected: (option) {
                      final filter = _menuOptionToFilterOption(option);
                      viewModel.updateSelectedFilter(filter);
                    },
                  ),
                ),
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
                // 하단 공간 (탭 바 등)
                Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCFCFC),
                    border: Border(
                      top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoalSelectionBar(TodoManageViewModel viewModel, List<Goal> goals) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          bool isSelected = viewModel.selectedGoalId == goal.id;
          return GestureDetector(
            onTap: () => viewModel.updateSelectedFilter(FilterOption.goal, goalId: goal.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF78B545) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE4F0D9)),
              ),
              child: Center(
                child: Text(
                  goal.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
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
    TodoManageViewModel viewModel, {
    required bool isDDay,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더
          GestureDetector(
            key: const Key('addTodoButton'),
            onTap: () {
              // 투두 추가 페이지 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TodoInputView(isDDayTodo: isDDay),
                ),
              ).then((_) => viewModel.loadTodos());
            },
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5, color: Color(0x3F1C1D1B)),
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.17,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.add, size: 12, color: Color(0xFF1C1D1B)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 투두 리스트
          todos.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return _buildTodoItem(context, todo, viewModel, isDDay: isDDay);
                  },
                )
              : const Text(
                  '투두가 없습니다.',
                  style: TextStyle(color: Colors.grey),
                ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(
    BuildContext context,
    Todo todo,
    TodoManageViewModel viewModel, {
    required bool isDDay,
  }) {
    final selectedDateOnly = DateTime(
      viewModel.selectedDate.year,
      viewModel.selectedDate.month,
      viewModel.selectedDate.day,
    );

    return TodoListItem(
      todo: todo,
      selectedDate: selectedDateOnly,
      onUpdate: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TodoInputView(todo: todo, isDDayTodo: isDDay),
          ),
        ).then((_) => viewModel.loadTodos());
      },
      onStatusUpdate: (updatedTodo, newStatus) => viewModel.updateTodoStatus(updatedTodo, newStatus),
      onDelete: () => viewModel.deleteTodoById(todo.id),
      onPostpone: () {
        final newStart = todo.startDate.add(const Duration(days: 1));
        final newEnd = todo.endDate.add(const Duration(days: 1));
        viewModel.updateTodoDates(todo, newStart, newEnd);
      },
      hideCompletionStatus: isDDay,
    );
  }

  MenuOption _filterOptionToMenuOption(FilterOption filter) {
    switch (filter) {
      case FilterOption.all:
        return MenuOption.all;
      case FilterOption.goal:
        return MenuOption.goal;
      case FilterOption.importance:
        return MenuOption.importance;
      default:
        return MenuOption.all;
    }
  }

  FilterOption _menuOptionToFilterOption(MenuOption option) {
    switch (option) {
      case MenuOption.all:
        return FilterOption.all;
      case MenuOption.goal:
        return FilterOption.goal;
      case MenuOption.importance:
        return FilterOption.importance;
      default:
        return FilterOption.all;
    }
  }
}
