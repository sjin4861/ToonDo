import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';

class GoalSelectionBar extends StatelessWidget {
  final List<Goal> goals;
  final String? selectedGoalId;
  final void Function(String goalId) onGoalSelected;

  const GoalSelectionBar({
    super.key,
    required this.goals,
    required this.selectedGoalId,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          final isSelected = selectedGoalId == goal.id;
          return GestureDetector(
            onTap: () => onGoalSelected(goal.id),
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
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}