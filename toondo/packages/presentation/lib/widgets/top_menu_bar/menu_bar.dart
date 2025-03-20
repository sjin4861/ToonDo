// lib/widgets/top_menu_bar/menu_bar.dart
import 'package:flutter/material.dart';

/// 원하는 메뉴 옵션을 enum으로 정의
enum MenuOption {
  all,   // 전체
  goal,  // 목표
  importance, // 중요
}

/// 가로로 3개의 버튼을 배치한 메뉴바
class MenuBarWidget extends StatelessWidget {
  final MenuOption selectedMenu;
  final ValueChanged<MenuOption> onItemSelected;

  const MenuBarWidget({
    Key? key,
    required this.selectedMenu,
    required this.onItemSelected,
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
          // Menu1 → 전체
          Expanded(
            child: _buildMenuItem(
              label: '전체',
              option: MenuOption.all,
            ),
          ),
          // Menu2 → 목표
          Expanded(
            child: _buildMenuItem(
              label: '목표',
              option: MenuOption.goal,
            ),
          ),
          // Menu3 → 중요
          Expanded(
            child: _buildMenuItem(
              label: '중요',
              option: MenuOption.importance,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String label,
    required MenuOption option,
  }) {
    bool isSelected = (option == selectedMenu);
    return GestureDetector(
      onTap: () => onItemSelected(option),
      child: Container(
        height: 40,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF78B545) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              letterSpacing: 0.21,
            ),
          ),
        ),
      ),
    );
  }
}