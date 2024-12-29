// lib/widgets/goal_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:todo_with_alarm/views/goal/goal_input_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;

  const GoalListItem({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 목표 진행률 계산
    double progress = goal.progress;

    // 목표 기간 포맷팅
    String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)} ~ ${DateFormat('yy.MM.dd').format(goal.endDate)}';

    // D-Day 계산
    int dDay = _calculateDDay(goal.endDate);

    // 아이콘 표시
    Widget iconWidget = goal.icon != null
        ? SvgPicture.asset(
            goal.icon!,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          )
        : const Icon(Icons.flag, color: Colors.grey); // 기본 아이콘

    return GestureDetector(
      onTap: () {
        // 목표 수정 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalInputScreen(targetGoal: goal),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: goal.isCompleted ? const Color(0xFFE4F0D9) : const Color(0xFFFFFEFB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 영역
            SizedBox(
              width: 40,
              height: 40,
              child: iconWidget,
            ),
            const SizedBox(width: 16),
            // 목표 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 목표 이름
                  Text(
                    goal.name,
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 목표 기간 및 D-Day
                  Row(
                    children: [
                      Text(
                        dateRange,
                        style: const TextStyle(
                          color: Color(0x7F1C1D1B),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'D-$dDay',
                        style: const TextStyle(
                          color: Color(0x7F1C1D1B),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 진행률 표시 영역
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  // 원형 진행률 표시
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      value: progress / 100,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C221F)),
                    ),
                  ),
                  // 진행률 텍스트
                  Center(
                    child: Text(
                      '${progress.toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFF2C221F),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 삭제 버튼
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () async {
                // GoalManagementViewModel을 통해 삭제 처리
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('삭제 확인'),
                    content: const Text('정말 이 목표를 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('삭제'),
                      ),
                    ],
                  ),
                );

                // 사용자가 삭제를 확인한 경우
                if (confirmDelete != null && confirmDelete) {
                  final viewModel = Provider.of<GoalManagementViewModel>(context, listen: false);
                  viewModel.deleteGoal(goal.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('목표가 삭제되었습니다.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int _calculateDDay(DateTime endDate) {
    final difference = endDate.difference(DateTime.now()).inDays;
    return difference >= 0 ? difference : 0;
  }
}