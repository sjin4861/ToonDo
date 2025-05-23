// lib/widgets/goal_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/entities/goal.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'dart:io';

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
    // 완료 여부
    final bool isCompleted = goal.status == Status.completed;
    // 진행률
    final double progress = goal.progress.clamp(0, 100);
    // 날짜 범위
    final String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)} ~ ${DateFormat('yy.MM.dd').format(goal.endDate)}';
    // D-Day
    final int dDay = _calculateDDay(goal.endDate);

    // 리스트 아이템 컨텐츠
    final content = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: ShapeDecoration(
        color: isCompleted ? const Color(0xFFEEEEEE) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isCompleted ? const Color(0x7FDDDDDD) : const Color(0xFF78B545),
          ),
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        onTap: onTap,
        leading: _buildGoalIcon(isCompleted),
        title: Text(
          goal.name,
          style: TextStyle(
            color:
                isCompleted
                    ? const Color(0x4C111111)
                    : const Color(0xFF1C1D1B),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.20,
            fontFamily: 'Pretendard Variable',
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: _buildDateSubtitle(dateRange, dDay),
        trailing: _buildProgressIndicator(progress),
      ),
    );
    // 스와이프 삭제 비활성화 시 단순 컨텐츠 반환
    if (!enableSwipeToDelete) return content;
    // 스와이프 삭제 기능 활성화
    return Dismissible(
      key: Key(goal.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(right: 12),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFB2D59D),
          borderRadius: BorderRadius.circular(1000),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 20,
        ),
      ),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => _onDelete(context),
      child: content,
    );
  }

  /// 오른쪽 스와이프 배경 (삭제)
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

  /// 삭제 확인 다이얼로그
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

  /// 삭제 로직 (GoalViewModel로 직접 접근)
  void _onDelete(BuildContext context) {
    final goalViewModel = Provider.of<GoalManagementViewModel>(context, listen: false);
    goalViewModel.deleteGoal(goal.id!);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('목표가 삭제되었습니다.')));
  }

  /// 아이콘 표시
  Widget _buildGoalIcon(bool isCompleted) {
    final Widget iconWidget;
    if (goal.icon != null) {
      String raw = goal.icon!;
      final fileName = raw.split('/').last;
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
        color: isCompleted ? const Color(0x7FDDDDDD) : const Color(0x1A78B545),
        borderRadius: BorderRadius.circular(16),
      ),
      child: iconWidget,
    );
  }

  /// 날짜 + D-Day
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

  /// 진행률 (가로형)
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

  /// D-Day 계산
  int _calculateDDay(DateTime endDate) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final int difference = endDate.difference(now).inDays;
    return difference >= 0 ? difference : 0;
  }
}
