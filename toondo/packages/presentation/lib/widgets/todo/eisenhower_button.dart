// lib/widgets/todo/eisenhower_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EisenhowerButton extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const EisenhowerButton({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonData = _getButtonData(index);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 90,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: isSelected ? buttonData['selectedBackgroundColor'] : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? buttonData['selectedBorderColor'] : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              buttonData['iconPath'],
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                isSelected ? buttonData['selectedTextColor'] : const Color.fromARGB(255, 18, 32, 47),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              buttonData['label'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? buttonData['selectedTextColor'] : buttonData['unselectedTextColor'],
                fontSize: 10,
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

  Map<String, dynamic> _getButtonData(int index) {
    switch (index) {
      case 0:
        return {
          'label': '중요하거나\n급하지 않아',
          'selectedBackgroundColor': const Color(0x7FE2DFDE),
          'selectedBorderColor': const Color(0x7FE2DFDE),
          'selectedTextColor': const Color(0xFF423B36),
          'unselectedTextColor': const Color(0x7F1C1D1B),
          'iconPath': 'assets/icons/ic_face_0.svg',
        };
      case 1:
        return {
          'label': '중요하지만\n급하지는 않아',
          'selectedBackgroundColor': const Color(0x7FE5F4FE),
          'selectedBorderColor': const Color(0x7FE5F4FE),
          'selectedTextColor': const Color(0xFF497895),
          'unselectedTextColor': const Color(0x7F1C1D1B),
          'iconPath': 'assets/icons/ic_face_1.svg',
        };
      case 2:
        return {
          'label': '급하지만\n중요하지 않아',
          'selectedBackgroundColor': const Color(0x7FFDF8DE),
          'selectedBorderColor': const Color(0x7FFDF8DE),
          'selectedTextColor': const Color(0xFF948436),
          'unselectedTextColor': const Color(0x7F1C1D1B),
          'iconPath': 'assets/icons/ic_face_2.svg',
        };
      case 3:
        return {
          'label': '중요하고\n급한일이야!',
          'selectedBackgroundColor': const Color(0x7FFCE9EA),
          'selectedBorderColor': const Color(0x7FFCE9EA),
          'selectedTextColor': const Color(0xFF91595A),
          'unselectedTextColor': const Color.fromARGB(126, 1, 1, 0),
          'iconPath': 'assets/icons/ic_face_3.svg',
        };
      default:
        throw ArgumentError('Invalid index');
    }
  }
}