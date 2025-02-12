// lib/widgets/goal/goal_options_bottom_sheet.dart

import 'package:flutter/material.dart';
import '../../data/models/goal.dart';
import '../../viewmodels/goal/goal_management_viewmodel.dart';
import '../../views/goal/goal_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalOptionsBottomSheet extends StatelessWidget {
  final Goal goal;

  const GoalOptionsBottomSheet({Key? key, required this.goal})
      : super(key: key);

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
          child: GoalInputScreen(targetGoal: goal), // 목표 수정 화면으로 네비게이션
        ),
      ),
    );
  }

  void _setProgress(BuildContext context) {
    final goalManagementVM = Provider.of<GoalManagementViewModel>(context, listen: false);
    final initialProgress = goal.progress;
    Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          double newProgress = initialProgress;

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
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      goalManagementVM.updateGoalProgress(goal.id!, newProgress);
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('저장'),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  void _giveUpGoal(BuildContext context) {
    final goalManagementVM = Provider.of<GoalManagementViewModel>(context, listen: false);
    Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('목표 포기하기'),
            content: const Text('정말로 이 목표를 포기하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  goalManagementVM.giveUpGoal(goal.id!);
                  Navigator.pop(dialogContext);
                },
                child: const Text('포기하기'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 메인 AxisSize를 최소화하여 바텀 시트의 높이를 유동적으로 조절
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          // "수정하기" 버튼
          ElevatedButton.icon(
            onPressed: () => _editGoal(context),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              '수정하기',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78B545),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // "진행률 설정" 버튼
          ElevatedButton.icon(
            onPressed: () => _setProgress(context),
            icon: const Icon(Icons.speed, color: Color(0xFF78B545)),
            label: const Text(
              '진행률 설정',
              style: TextStyle(color: Color(0xFF78B545), fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Color(0xFF78B545), width: 1),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 12),

          // "포기하기" 버튼
          ElevatedButton.icon(
            onPressed: () => _giveUpGoal(context),
            icon: const Icon(Icons.close, color: Color(0xFF78B545)),
            label: const Text(
              '포기하기',
              style: TextStyle(color: Color(0xFF78B545), fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Color(0xFF78B545), width: 1),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}