// lib/widgets/goal_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/goal.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalListItem({
    Key? key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 목표 진행률 계산
    double progress = goal.progress ?? 0.0;

    // 목표 기간 포맷팅
    String dateRange =
        '${DateFormat('yy.MM.dd').format(goal.startDate)}~${DateFormat('yy.MM.dd').format(goal.endDate)}';

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // 패딩 조정
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: ShapeDecoration(
          color: const Color(0xFFFFFEFB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 진행률 표시 영역
            SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                children: [
                  // 원형 진행률 표시
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: progress / 100,
                        strokeWidth: 4,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C221F)),
                      ),
                    ),
                  ),
                  // 진행률 텍스트
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Text(
                          '${progress.toInt()}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF2C221F),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 목표 이름 및 기간
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                      color: Color(0xFF1B1C1B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0.18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateRange,
                    style: const TextStyle(
                      color: Color(0xFF8D8E8D),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 삭제 버튼
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () async {
                  // 삭제 확인 다이얼로그 표시
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
                    try {
                      await goal.delete(); // Hive에서 Goal 삭제
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('목표가 삭제되었습니다.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
                      );
                    }
                  }
                },
              ),
            ),           
          ],
        ),
      ),
    );
  }
}