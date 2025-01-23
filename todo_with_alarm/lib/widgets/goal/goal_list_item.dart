// lib/widgets/goal_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_management_viewmodel.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;

  const GoalListItem({
    Key? key,
    required this.goal,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 완료 여부
    bool isCompleted = goal.isCompleted;
    // 진행률
    double progress = goal.progress.clamp(0, 100);
    // 날짜 범위
    String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)} ~ ${DateFormat('yy.MM.dd').format(goal.endDate)}';
    // D-Day
    int dDay = _calculateDDay(goal.endDate);

    return Dismissible(
      key: Key(goal.id ?? ''),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => _onDelete(context),
      child: Container(
        // 아이템간 간격
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: ShapeDecoration(
          color: isCompleted ? const Color(0xFFEEEEEE) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color:
                  isCompleted ? const Color(0x7FDDDDDD) : const Color(0xFF78B545),
            ),
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
        child: ListTile(
          // 1) 텍스트 오른쪽으로 더 밀어주기
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          onTap: onTap,
          // 아이콘 부분
          leading: _buildGoalIcon(isCompleted),
          // 목표 이름
          title: Text(
            goal.name,
            style: TextStyle(
              color:
                  isCompleted ? const Color(0x4C111111) : const Color(0xFF1C1D1B),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.20,
              fontFamily: 'Pretendard Variable',
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          // 날짜 + D-Day
          subtitle: _buildDateSubtitle(dateRange, dDay),
          // 진행률 (LinearProgressIndicator)
          trailing: _buildProgressIndicator(progress),
        ),
      ),
    );
  }

  /// Dismissible 배경
  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(1000),
        ),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  /// 삭제 전 확인 다이얼로그
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
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
  }

  /// 삭제 로직
  void _onDelete(BuildContext context) {
    final viewModel =
        Provider.of<GoalManagementViewModel>(context, listen: false);
    viewModel.deleteGoal(goal.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('목표가 삭제되었습니다.')),
    );
  }

  /// 아이콘 표시
  Widget _buildGoalIcon(bool isCompleted) {
    // 2) 아이콘 크기 확대
    Widget iconWidget = (goal.icon != null)
        ? SvgPicture.asset(
            goal.icon!,
            fit: BoxFit.cover,
            width: 24,
            height: 24,
          )
        : const Icon(Icons.flag, color: Colors.grey, size: 24);

    return Container(
      // 기존 24 → 32로 확대
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0x7FDDDDDD)
            : const Color(0x1A78B545),
        borderRadius: BorderRadius.circular(16),
      ),
      child: iconWidget,
    );
  }

  /// 날짜 + D-Day 부분
  Widget _buildDateSubtitle(String dateRange, int dDay) {
    return Row(
      children: [
        Text(
          dateRange,
          style: const TextStyle(
            color: Color(0x7F1C1D1B),
            fontSize: 8,
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
            fontSize: 8,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.12,
          ),
        ),
      ],
    );
  }

  /// 진행률
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
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF78B545)),
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

  /// D-Day 계산
  int _calculateDDay(DateTime endDate) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    int difference = endDate.difference(now).inDays;
    return difference >= 0 ? difference : 0;
  }
}