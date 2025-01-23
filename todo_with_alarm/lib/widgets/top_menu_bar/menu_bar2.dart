// lib/widgets/top_menu_bar/menu_bar2.dart
import 'package:flutter/material.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_management_viewmodel.dart';

class TwoMenuBarWidget extends StatelessWidget {
  final GoalFilterOption selectedOption;
  final ValueChanged<GoalFilterOption> onOptionSelected;

  const TwoMenuBarWidget({
    Key? key,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE4F0D9)),
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Row(
        children: [
          // 진행 중
          Expanded(
            child: GestureDetector(
              onTap: () => onOptionSelected(GoalFilterOption.inProgress),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: selectedOption == GoalFilterOption.inProgress
                      ? const Color(0xFF78B545)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(1000),
                      bottomLeft: Radius.circular(1000),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '진행 중',
                    style: TextStyle(
                      color: selectedOption == GoalFilterOption.inProgress
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: selectedOption == GoalFilterOption.inProgress
                          ? FontWeight.w700
                          : FontWeight.w400,
                      letterSpacing: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 진행 완료
          Expanded(
            child: GestureDetector(
              onTap: () => onOptionSelected(GoalFilterOption.completed),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: selectedOption == GoalFilterOption.completed
                      ? const Color(0xFF78B545)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(1000),
                      bottomRight: Radius.circular(1000),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '진행 완료',
                    style: TextStyle(
                      color: selectedOption == GoalFilterOption.completed
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: selectedOption == GoalFilterOption.completed
                          ? FontWeight.w700
                          : FontWeight.w400,
                      letterSpacing: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}