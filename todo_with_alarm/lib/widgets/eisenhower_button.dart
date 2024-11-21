// lib/widgets/eisenhower_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EisenhowerButton extends StatelessWidget {
  final int index;
  final String label;
  final bool isSelected;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final VoidCallback onTap;
  final String iconPath;

  const EisenhowerButton({
    Key? key,
    required this.index,
    required this.label,
    required this.isSelected,
    required this.selectedBackgroundColor,
    required this.selectedBorderColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.onTap,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: isSelected ? selectedBackgroundColor : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? selectedBorderColor : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                isSelected ? selectedTextColor : const Color.fromARGB(255, 18, 32, 47),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? selectedTextColor : unselectedTextColor,
                fontSize: 8,
                fontFamily: 'Pretendard Variable',
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                height: 1.0,
                letterSpacing: 0.12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}