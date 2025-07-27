// lib/widgets/todo_edit_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/goal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToDoEditBottomSheet extends StatelessWidget {
  final Todo todo;
  final List<Goal> goals; // 추가: 부모로부터 goals 리스트를 전달받음
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onPostpone;
  final Function(double) onStatusUpdate; // onStatusUpdate 속성 추가

  const ToDoEditBottomSheet({
    super.key,
    required this.todo,
    required this.goals,
    required this.onUpdate,
    required this.onDelete,
    required this.onPostpone,
    required this.onStatusUpdate, // 생성자에 goals 추가
  });

  @override
  Widget build(BuildContext context) {
    bool isDDay = todo.isDDayTodo();

    // 목표 아이콘 표시를 위한 matchingGoal 추출
    final matchingGoal = goals.firstWhere(
      (g) => g.id == todo.goalId
    );

    return Container(
      height: 320,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: Stack(
        children: [
          // 상단 바
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 63,
            top: 22,
            child: Container(
              width: 126,
              height: 8,
              decoration: ShapeDecoration(
                color: Color(0xFFDAEBCB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
            ),
          ),
          // 목표 아이콘 및 제목 표시 (골옵션 스타일과 동일)
          Positioned(
            top: 59,
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: matchingGoal.icon != null
                      ? SvgPicture.asset(
                          matchingGoal.icon!,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.flag,
                          size: 18,
                          color: Color(0xFF78B545),
                        ),
                ),
                const SizedBox(width: 12),
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                    color: Color(0xFF1C1D1B),
                  ),
                ),
              ],
            ),
          ),
          // 수정하기 버튼
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 106,
            top: 112,
            child: GestureDetector(
              onTap: () {
                onUpdate();
              },
              child: Container(
                width: 212,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: ShapeDecoration(
                  color: Color(0xFF78B545),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
          ),
          // 삭제하기 버튼
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 106,
            top: 176,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 212,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF78B545)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, size: 24, color: Color(0xFF78B545)),
                    SizedBox(width: 8),
                    Text(
                      '삭제하기',
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
          ),
          // 내일로 미루기 버튼 (디데이 투두가 아닌 경우에만 표시)
          if (!isDDay)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 106,
              top: 240,
              child: GestureDetector(
                onTap: onPostpone,
                child: Container(
                  width: 212,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF78B545)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward,
                          size: 24, color: Color(0xFF78B545)),
                      SizedBox(width: 8),
                      Text(
                        '내일하기',
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
            ),
          // 진행률 수정 버튼 (디데이 투두인 경우)
          if (isDDay)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 106,
              top: 240,
              child: GestureDetector(
                onTap: () {
                  _showProgressUpdateDialog(context);
                },
                child: Container(
                  width: 212,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: ShapeDecoration(
                    color: Color(0xFF78B545),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 24, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '진행률 수정',
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
            ),
        ],
      ),
    );
  }

  // 진행률 업데이트 다이얼로그 메서드
  void _showProgressUpdateDialog(BuildContext context) {
    double newStatus = todo.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('진행률 수정'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('진행률: ${newStatus.toInt()}%'),
                  Slider(
                    value: newStatus,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${newStatus.toInt()}%',
                    onChanged: (double value) {
                      setStateDialog(() {
                        newStatus = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    // 진행률 업데이트
                    await _updateTodoStatus(context, newStatus);
                    Navigator.pop(context);
                  },
                  child: Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateTodoStatus(BuildContext context, double newStatus) async {
    try {
      // 진행률 업데이트 콜백 호출
      onStatusUpdate(newStatus);
    } catch (e) {
      // 에러 처리 로직 추가 (예: 로그 기록, 사용자 알림 등)
      print('Error updating todo status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('진행률 업데이트에 실패했습니다.')),
      );
    }
  }
}