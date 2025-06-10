import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:presentation/widgets/top_menu_bar/menu_bar2.dart';

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
    return TwoMenuBarWidget(
      selectedStatus: selectedStatus,
      onStatusSelected: onStatusSelected,
    );
  }
}
