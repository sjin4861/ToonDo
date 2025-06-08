import 'package:flutter/material.dart';
import 'package:presentation/widgets/top_menu_bar/menu_bar.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';

class TodoFilterSection extends StatelessWidget {
  final FilterOption selectedFilter;
  final void Function(FilterOption) onFilterSelected;

  const TodoFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MenuBarWidget(
          selectedMenu: _filterOptionToMenuOption(selectedFilter),
          onItemSelected: (option) => onFilterSelected(
            _menuOptionToFilterOption(option),
          ),
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
    }
  }
}