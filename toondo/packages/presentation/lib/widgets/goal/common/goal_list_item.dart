import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presentation/views/goal/input/goal_input_screen.dart';
import 'package:presentation/widgets/goal/manage/goal_edit_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;
  final bool enableSwipeToDelete;

  const GoalListItem({
    Key? key,
    required this.goal,
    this.onTap,
    this.enableSwipeToDelete = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: goal.id != null ? Key(goal.id!) : UniqueKey(),
      direction:
          enableSwipeToDelete
              ? DismissDirection.endToStart
              : DismissDirection.none,
      background: _buildDismissBackground(),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => _onDelete(context),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => GoalEditBottomSheet(
                iconPath: _resolveGoalIconPath(goal.icon),
                title: goal.name,
                onRetry: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoalInputScreen(goal: goal),
                    ),
                  );
                },
                onDelete: () {
                  Navigator.pop(context);
                  _onDelete(context);
                },
              ),
            );
          },
          child: _buildContent(context),
        ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bool isCompleted = goal.status == Status.completed;
    final double progress = goal.progress.clamp(0, 100);
    final String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)} ~ ${DateFormat('yy.MM.dd').format(goal.endDate)}';
    final int dDay = _calculateDDay(goal.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFAED38F), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGoalIcon(isCompleted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: _titleStyle.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _buildDateSubtitle(dateRange, dDay),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildProgressIndicator(progress),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(1000)),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 24),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('삭제 확인'),
            content: const Text('정말 이 목표를 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  void _onDelete(BuildContext context) {
    final goalViewModel = Provider.of<GoalManagementViewModel>(
      context,
      listen: false,
    );
    goalViewModel.deleteGoal(goal.id!);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('목표가 삭제되었습니다.')));
  }

  Widget _buildGoalIcon(bool isCompleted) {
    final Widget iconWidget;
    if (goal.icon != null) {
      final fileName = goal.icon!.split('/').last;
      final normalized = fileName.startsWith('ic_') ? fileName : 'ic_$fileName';
      final path = 'assets/icons/$normalized';
      iconWidget = SvgPicture.asset(
        path,
        fit: BoxFit.cover,
        width: 24,
        height: 24,
      );
    } else {
      iconWidget = const Icon(Icons.flag, color: Colors.grey, size: 24);
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFAED38F), width: 1.5),
      ),
      child: iconWidget,
    );
  }

  Widget _buildDateSubtitle(String dateRange, int dDay) {
    return Wrap(
      spacing: 8,
      children: [
        Text(dateRange, style: _subtitleStyle),
        Text('D-$dDay', style: _subtitleStyle),
      ],
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF78B545),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${progress.toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1D1B),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDDay(DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final int difference = endDate.difference(today).inDays;
    return difference >= 0 ? difference : 0;
  }

  String _resolveGoalIconPath(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return 'assets/icons/ic_default.svg';
    }

    final fileName = iconName.split('/').last;
    final normalized = fileName.startsWith('ic_') ? fileName : 'ic_$fileName';
    return 'assets/icons/$normalized';
  }


  TextStyle get _titleStyle => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.0,
    fontFamily: 'Pretendard Variable',
  );

  TextStyle get _subtitleStyle => const TextStyle(
    color: Colors.grey,
    fontSize: 8,
    fontFamily: 'Pretendard Variable',
    fontWeight: FontWeight.w400,
    letterSpacing: 0.12,
    height: 1.0,
  );
}
