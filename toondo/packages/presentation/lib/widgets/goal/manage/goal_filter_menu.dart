import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:presentation/widgets/top_menu_bar/tab_menu_bar.dart';

class GoalFilterMenu extends StatelessWidget {
  final Status selectedStatus;
  final void Function(Status) onStatusSelected;

  const GoalFilterMenu({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabMenuBar<Status>(
      options: const [Status.active, Status.completed],
      selected: selectedStatus,
      onSelected: onStatusSelected,
      labelBuilder: (status) {
        switch (status) {
          case Status.active:
            return '전체';
          case Status.completed:
            return '완료';
          default:
            return '';
        }
      },
    );
  }
}
