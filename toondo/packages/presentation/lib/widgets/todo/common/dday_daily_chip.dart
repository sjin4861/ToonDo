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
        _buildChip(
          label: '디데이',
          selected: !isDailySelected,
          onTap: () => onToggle(false),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        _buildChip(
          label: '데일리',
          selected: isDailySelected,
          onTap: () => onToggle(true),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    const borderColor = Color(0xFF78B545);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? borderColor : Colors.transparent,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor),
        ),
        child: Builder(
          builder: (context) => Text(
            label,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: 10,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w400,
              fontFamily: 'Pretendard Variable',
              height: 1.0,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ),
    );
  }
}
