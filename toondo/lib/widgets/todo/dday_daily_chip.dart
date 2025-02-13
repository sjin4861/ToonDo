import 'package:flutter/material.dart';

class DdayDailyChip extends StatelessWidget {
  final bool isDailySelected;
  final Function(bool isDaily) onToggle;

  const DdayDailyChip({
    super.key,
    required this.isDailySelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onToggle(false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: ShapeDecoration(
              color: !isDailySelected ? const Color(0xFF78B545) : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF78B545)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(1000),
                  bottomLeft: Radius.circular(1000),
                ),
              ),
            ),
            child: Text(
              '디데이',
              style: TextStyle(
                color: !isDailySelected ? Colors.white : const Color(0xFF1C1D1B),
                fontSize: 10,
                fontFamily: 'Pretendard',
                fontWeight: !isDailySelected ? FontWeight.w700 : FontWeight.w400,
                height: 1.40,
                letterSpacing: 0.12,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => onToggle(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: ShapeDecoration(
              color: isDailySelected ? const Color(0xFF78B545) : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF78B545)),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(1000),
                  bottomRight: Radius.circular(1000),
                ),
              ),
            ),
            child: Text(
              '데일리',
              style: TextStyle(
                color: isDailySelected ? Colors.white : const Color(0xFF1C1D1B),
                fontSize: 10,
                fontFamily: 'Pretendard',
                fontWeight: isDailySelected ? FontWeight.w700 : FontWeight.w400,
                height: 1.40,
                letterSpacing: 0.12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}