import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
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
        builder: (_) => ChangeNotifierProvider<GoalInputViewModel>(
          create: (_) => GoalInputViewModel(
            createGoalRemoteUseCase: GetIt.instance<CreateGoalRemoteUseCase>(),
            saveGoalLocalUseCase: GetIt.instance<SaveGoalLocalUseCase>(),
            updateGoalRemoteUseCase: GetIt.instance<UpdateGoalRemoteUseCase>(),
            updateGoalLocalUseCase: GetIt.instance<UpdateGoalLocalUseCase>(),
            targetGoal: goal,
          ),
          child: GoalInputScreen(goal: goal),
        ),
      ),
    );
  }

  void _setProgress(BuildContext context) {
    final goalManagementVM = Provider.of<GoalManagementViewModel>(
      context,
      listen: false,
    );
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
                      goalManagementVM.updateGoalProgress(
                        goal.id!,
                        newProgress,
                      );
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
    final goalManagementVM = Provider.of<GoalManagementViewModel>(
      context,
      listen: false,
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFD7E9CD),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 28),
          // 아이콘 + 목표 이름
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF78B545), width: 1),
                ),
                child: goal.icon != null
                    ? SvgPicture.asset(
                        'assets/icons/${goal.icon!.split('/').last}',
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.flag, size: 18, color: Color(0xFF78B545)),
              ),
              const SizedBox(width: 12),
              Text(
                goal.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF1C1D1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // 수정하기 버튼
          Center(
            child: _FilledActionButton(
              icon: Icons.edit,
              label: '수정하기',
              width: 212,
              height: 56,
              borderRadius: 20,
              onPressed: () => _editGoal(context),
            ),
          ),
          const SizedBox(height: 16),
          // 진행률 설정 버튼
          Center(
            child: _OutlinedActionButton(
              icon: Icons.speed,
              label: '진행률 설정',
              width: 212,
              height: 56,
              borderRadius: 20,
              onPressed: () => _setProgress(context),
            ),
          ),
          const SizedBox(height: 16),
          // 포기하기 버튼
          Center(
            child: _OutlinedActionButton(
              icon: Icons.delete_outline,
              label: '포기하기',
              width: 212,
              height: 56,
              borderRadius: 20,
              borderColor: const Color(0xFFE24E4E),
              foreground: const Color(0xFFE24E4E),
              onPressed: () => _giveUpGoal(context),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// 재사용 가능한 버튼 위젯
class _FilledActionButton extends StatelessWidget {
  const _FilledActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 18,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF78B545),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.borderColor = const Color(0xFF78B545),
    this.foreground = const Color(0xFF78B545),
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 18,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color foreground;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foreground, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          foregroundColor: foreground,
        ),
      ),
    );
  }
}
