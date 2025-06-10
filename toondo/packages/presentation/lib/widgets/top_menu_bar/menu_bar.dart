import 'package:flutter/material.dart';

enum MenuOption { all, goal, importance }

class MenuBarWidget extends StatelessWidget {
  final MenuOption selectedMenu;
  final ValueChanged<MenuOption> onItemSelected;

  const MenuBarWidget({
    super.key,
    required this.selectedMenu,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      {'label': '전체', 'option': MenuOption.all},
      {'label': '목표', 'option': MenuOption.goal},
      {'label': '중요', 'option': MenuOption.importance},
    ];

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
          final label = options[index]['label'] as String;
          final option = options[index]['option'] as MenuOption;
          final isSelected = option == selectedMenu;

          final isFirst = index == 0;
          final isLast = index == options.length - 1;

          // 하단 라운드 조건 설정
          Radius bottomLeft = Radius.zero;
          Radius bottomRight = Radius.zero;

          if (isSelected) {
            if (isFirst) {
              bottomLeft = const Radius.circular(8);
            } else if (isLast) {
              bottomRight = const Radius.circular(8);
            }
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF78B545) : backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                    bottomLeft: bottomLeft,
                    bottomRight: bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isSelected
                            ? Colors.white
                            : Colors.black.withOpacity(0.5),
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
