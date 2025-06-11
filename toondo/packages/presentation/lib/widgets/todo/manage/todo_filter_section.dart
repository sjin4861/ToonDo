import 'package:flutter/material.dart';
import 'package:domain/entities/todo_filter_option.dart';
import 'package:presentation/widgets/top_menu_bar/tab_menu_bar.dart';

class TodoFilterSection extends StatelessWidget {
  final TodoFilterOption selectedFilter;
  final void Function(TodoFilterOption) onFilterSelected;

  const TodoFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabMenuBar<TodoFilterOption>(
      options: const [
        TodoFilterOption.all,
        TodoFilterOption.goal,
        TodoFilterOption.importance,
      ],
      selected: selectedFilter,
      onSelected: onFilterSelected,
      labelBuilder: _buildLabel,
    );
  }

  String _buildLabel(TodoFilterOption option) {
    switch (option) {
      case TodoFilterOption.all:
        return '전체';
      case TodoFilterOption.goal:
        return '목표';
      case TodoFilterOption.importance:
        return '중요';
      case TodoFilterOption.dDay:
        return 'D-Day';
      case TodoFilterOption.daily:
        return '일반';
    }
  }
}
