// lib/widgets/goal/goal_options_bottom_sheet.dart

import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../viewmodels/goal/goal_management_viewmodel.dart';
import '../../views/goal/goal_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';

class GoalOptionsBottomSheet extends StatelessWidget {
  final Goal goal;

  const GoalOptionsBottomSheet({Key? key, required this.goal}) : super(key: key);

  void _editGoal(BuildContext context) {
    Navigator.pop(context); // 바텀 시트 닫기
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<GoalInputViewModel>(
          create: (context) => GoalInputViewModel(
            goalService: Provider.of<GoalService>(context, listen: false),
            targetGoal: goal,
          ),
          child: GoalInputScreen(targetGoal: goal), // 목표 수정 화면
        ),
      ),
    );
  }

  void _setProgress(BuildContext context) {
    Navigator.pop(context); // 바텀 시트 닫기
    showDialog(
      context: context,
      builder: (context) {
        double newProgress = goal.progress;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('진행률 설정'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('진행률: ${newProgress.toInt()}%'),
                  Slider(
                    value: newProgress,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${newProgress.toInt()}%',
                    onChanged: (double value) {
                      setStateDialog(() {
                        newProgress = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 진행률 업데이트
                    Provider.of<GoalManagementViewModel>(context, listen: false)
                        .updateGoalProgress(goal.id!, newProgress);
                    Navigator.pop(context);
                  },
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _giveUpGoal(BuildContext context) {
    Navigator.pop(context); // 바텀 시트 닫기
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('목표 포기하기'),
          content: const Text('정말로 이 목표를 포기하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 목표 포기 로직
                Provider.of<GoalManagementViewModel>(context, listen: false)
                    .giveUpGoal(goal.id!);
                Navigator.pop(context);
              },
              child: const Text('포기하기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // 바텀 시트 높이 조정
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          const SizedBox(height: 16),
          Container(
            width: 126,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFDAEBCB),
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
          const SizedBox(height: 24),

          // "수정하기" 버튼
          GestureDetector(
            onTap: () => _editGoal(context),
            child: Container(
              width: 212,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: ShapeDecoration(
                color: const Color(0xFF78B545),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.edit,
                    size: 24,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '수정하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // "진행률 설정" 버튼
          GestureDetector(
            onTap: () => _setProgress(context),
            child: Container(
              width: 212,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF78B545)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.speed,
                    size: 24,
                    color: Color(0xFF78B545),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '진행률 설정',
                    style: TextStyle(
                      color: Color(0xFF78B545),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // "포기하기" 버튼
          GestureDetector(
            onTap: () => _giveUpGoal(context),
            child: Container(
              width: 212,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF78B545)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.close,
                    size: 24,
                    color: Color(0xFF78B545),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '포기하기',
                    style: TextStyle(
                      color: Color(0xFF78B545),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}