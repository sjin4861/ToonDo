import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:domain/entities/goal.dart';

class GoalListDropdown extends StatelessWidget {
  final String? selectedGoalId;
  final List<Goal> goals;
  final bool isDropdownOpen;
  final Function(String?) onGoalSelected;
  final Function() toggleDropdown;

  const GoalListDropdown({
    Key? key,
    required this.selectedGoalId,
    required this.goals,
    required this.isDropdownOpen,
    required this.onGoalSelected,
    required this.toggleDropdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultGoal = Goal(
      id: '',
      name: '목표 미설정',
      icon: Assets.icons.icMonster.path,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );

    final List<Goal> effectiveGoals =
        goals.isEmpty ? [defaultGoal] : [...goals, defaultGoal];

    final Goal? selectedGoal = goals.firstWhere(
      (goal) => goal.id == selectedGoalId,
      orElse: () => defaultGoal,
    );

    final bool isUnselected = selectedGoalId == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F0D9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _buildIcon(
                  isUnselected ? null : selectedGoal?.icon,
                  isSelected: true,
                  fallbackIcon: Icons.help_outline,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isUnselected
                        ? '목표를 선택하세요.'
                        : selectedGoal?.name ?? '목표 미설정',
                    style: const TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.14,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                ),
                Icon(
                  isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Color(0xFF1C1D1B),
                ),
              ],
            ),
          ),
        ),
        if (isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDDDDD)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: List.generate(
                effectiveGoals.length * 2 - 1,
                    (index) {
                  if (index.isOdd) {
                    return const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFDDDDDD),
                    );
                  } else {
                    final goal = effectiveGoals[index ~/ 2];
                    return GestureDetector(
                      onTap: () => onGoalSelected(goal.id),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 40,
                          color: selectedGoalId == goal.id
                              ? const Color(0x80E4F0DA)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              _buildIcon(
                                goal.icon,
                                isSelected: selectedGoalId == goal.id,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  goal.name,
                                  style: TextStyle(
                                    color: const Color(0xFF1C1D1B),
                                    fontSize: 12,
                                    fontWeight: selectedGoalId == goal.id
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                    height: 1.33,
                                    letterSpacing: 0.14,
                                    fontFamily: 'Pretendard Variable',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon(
    String? iconPath, {
    required bool isSelected,
    IconData fallbackIcon = Icons.help_outline,
  }) {
    Widget iconWidget;
    if (iconPath != null && iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(iconPath, fit: BoxFit.cover);
    } else {
      iconWidget = Icon(fallbackIcon, size: 16, color: Colors.white);
    }

    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x7FAED28F) : const Color(0x7FDDDDDD),
        shape: BoxShape.circle,
      ),
      child: iconWidget,
    );
  }
}
