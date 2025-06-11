import 'package:flutter/material.dart';

class TabMenuBar<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;

  const TabMenuBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        border: Border.all(color: const Color(0xFFE4F0DA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = options[index] == selected;
          final isFirst = index == 0;
          final isLast = index == options.length - 1;

          final topLeft = const Radius.circular(8);
          final topRight = const Radius.circular(8);

          // 하단 둥글기 설정: 외곽 테두리와 맞춰야 하므로 선택된 항목에 따라 다름
          final bottomLeft = isFirst && isSelected ? const Radius.circular(8) : Radius.zero;
          final bottomRight = isLast && isSelected ? const Radius.circular(8) : Radius.zero;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(options[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF78B545) : backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: topLeft,
                    topRight: topRight,
                    bottomLeft: bottomLeft,
                    bottomRight: bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labelBuilder(options[index]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
                    fontSize: 14,
                    height: 1.0,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
