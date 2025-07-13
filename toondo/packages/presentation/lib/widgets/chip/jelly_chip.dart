import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 1) JellyChip 위젯
///  - 크기: width 약 50~60, height: 28
///  - 내부: Row(젤리 아이콘 + 텍스트)
class JellyChip extends StatelessWidget {
  final int jellyAmount; // 예: 100
  final double chipWidth; // 기본값 51
  final double chipHeight; // 기본값 28
  final String jellyIconPath; // 젤리 아이콘 경로 (assets/icons/img_jelly.svg)

  const JellyChip({
    super.key,
    required this.jellyAmount,
    this.chipWidth = 51,
    this.chipHeight = 28,
    this.jellyIconPath = 'assets/icons/img_jelly.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: chipWidth,
      height: chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: Color(0x3F1C1D1B)),
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 젤리 아이콘
          SvgPicture.asset(
            jellyIconPath,
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 4),
          // 젤리 수량
          Text(
            '$jellyAmount',
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 11,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.45,
              letterSpacing: 0.13,
            ),
          ),
        ],
      ),
    );
  }
}
