import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../chip/jelly_chip.dart';

/// ItemCard 위젯
///  - 크기: width=74, height=102
///  - 내부: 아이콘(56x56), 아래로 아이템명, 그리고 젤리칩
class ItemCard extends StatelessWidget {
  final String itemName; // 예: '커피 한 잔'
  final int price; // 예: 100
  final String iconPath; // 예: 'assets/icons/img_cup_of_coffee.svg'
  final bool isSelected; // 선택된 상태 표현 등 (옵션)
  final VoidCallback? onTap; // 구매나 클릭 이벤트

  const ItemCard({
    Key? key,
    required this.itemName,
    required this.price,
    required this.iconPath,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 테두리 색: 선택 상태에 따라 다르게 표현 가능
    final borderColor =
        isSelected ? const Color(0xFF78B545) : const Color(0x3F1C1D1B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        height: 102,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            // 1) 아이템명
            Positioned(
              left: 9,
              top: 62,
              child: SizedBox(
                width: 56,
                child: Text(
                  itemName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    letterSpacing: 0.13,
                  ),
                ),
              ),
            ),
            // 2) 젤리칩 (가격)
            Positioned(
              left: 9,
              top: 82,
              child: SizedBox(
                width: 56,
                child: Center(
                  child: JellyChip(
                    jellyAmount: price,
                    chipWidth: 40,
                    chipHeight: 18,
                    // 아이콘 경로가 다르면 교체
                    jellyIconPath: 'assets/icons/img_jelly.svg',
                  ),
                ),
              ),
            ),
            // 3) 아이템 아이콘
            Positioned(
              left: 9,
              top: 6,
              child: SizedBox(
                width: 56,
                height: 56,
                // padding, alignment 등 원하는 대로
                child: SvgPicture.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
