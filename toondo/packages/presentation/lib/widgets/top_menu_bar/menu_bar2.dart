import 'package:flutter/material.dart';
import 'package:domain/entities/status.dart'; // GoalFilterOption 제거 후 Status 사용

class TwoMenuBarWidget extends StatelessWidget {
  final Status selectedStatus;
  final ValueChanged<Status> onStatusSelected;

  const TwoMenuBarWidget({
    Key? key,
    required this.selectedStatus,
    required this.onStatusSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE4F0D9)),
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Row(
        children: [
          // 진행 중 (Status.active)
          Expanded(
            child: GestureDetector(
              onTap: () => onStatusSelected(Status.active),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: selectedStatus == Status.active
                      ? const Color(0xFF78B545)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(1000),
                      bottomLeft: Radius.circular(1000),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '진행 중',
                    style: TextStyle(
                      color: selectedStatus == Status.active
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: selectedStatus == Status.active
                          ? FontWeight.w700
                          : FontWeight.w400,
                      letterSpacing: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 진행 완료 (Status.completed)
          Expanded(
            child: GestureDetector(
              onTap: () => onStatusSelected(Status.completed),
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: selectedStatus == Status.completed
                      ? const Color(0xFF78B545)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(1000),
                      bottomRight: Radius.circular(1000),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '진행 완료',
                    style: TextStyle(
                      color: selectedStatus == Status.completed
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: selectedStatus == Status.completed
                          ? FontWeight.w700
                          : FontWeight.w400,
                      letterSpacing: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}