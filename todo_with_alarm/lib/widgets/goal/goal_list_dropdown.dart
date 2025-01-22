import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_with_alarm/models/goal.dart';

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
    // 기본값 설정
    final defaultGoal = Goal(
      id: '',
      name: '목표 미설정',
      icon: null,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );

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
                  goals
                      .firstWhere(
                          (goal) => goal.id == selectedGoalId,
                          orElse: () => defaultGoal)
                      .icon,
                  isSelected: true,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    selectedGoalId != null
                        ? goals
                            .firstWhere(
                                (goal) => goal.id == selectedGoalId,
                                orElse: () => defaultGoal)
                            .name
                        : '목표를 선택하세요.',
                    style: const TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.14,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
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
              children: goals.map((goal) {
                return GestureDetector(
                  onTap: () => onGoalSelected(goal.id),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: selectedGoalId == goal.id
                        ? const Color(0xFFE4F0D9)
                        : Colors.transparent,
                    child: Row(
                      children: [
                        _buildIcon(goal.icon,
                            isSelected: selectedGoalId == goal.id),
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
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // 아이콘 위젯을 생성하는 메서드
  Widget _buildIcon(String? iconPath, {required bool isSelected}) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0x7FAED28F)
            : const Color(0x7FDDDDDD),
        shape: BoxShape.circle,
      ),
      child: iconPath != null
          ? SvgPicture.asset(
            iconPath,
            fit: BoxFit.cover
          )
          : Icon(Icons.help_outline, size: 16, color: Colors.white),
    );
  }
}