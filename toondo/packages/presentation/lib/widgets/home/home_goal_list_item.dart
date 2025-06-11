import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:domain/entities/goal.dart';

class HomeGoalListItem extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;

  const HomeGoalListItem({
    Key? key,
    required this.goal,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = goal.progress.clamp(0, 100);
    final String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)} ~ ${DateFormat('yy.MM.dd').format(goal.endDate)}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Row(
          children: [
            _buildCircularProgress(progress),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard Variable',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateRange,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(double progress) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 3,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF78B545),
            ),
          ),
          Text(
            '${progress.toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1D1B),
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ],
      ),
    );
  }
}
