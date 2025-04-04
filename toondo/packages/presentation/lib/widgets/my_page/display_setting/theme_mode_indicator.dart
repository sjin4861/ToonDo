import 'package:flutter/material.dart';

class ThemeModeIndicator extends StatelessWidget {
  final bool isSelected;

  const ThemeModeIndicator({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF78B545) : const Color(0xFFB4B4B4),
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
        child: Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF78B545),
          ),
        ),
      )
          : null,
    );
  }
}
