import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme_mode_indicator.dart';

class ThemeModeOptionTile extends StatelessWidget {
  final ThemeMode mode;
  final bool selected;

  const ThemeModeOptionTile({
    super.key,
    required this.mode,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = mode == ThemeMode.light;

    final backgroundColor = isLight
        ? const Color(0xFFFDFDFD)
        : const Color(0xFF444444);

    final borderColor = isLight
        ? (selected ? const Color(0xFF78B545) : const Color(0xFFD9D9D9))
        : Colors.transparent;

    final iconColor = isLight
        ? const Color(0x801C1D1B)
        : const Color(0xA6FFFFFF);

    return Column(
      children: [
        Container(
          width: 145,
          height: 96,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/face0.svg',
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isLight ? '라이트' : '다크',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1D1B),
          ),
        ),
        const SizedBox(height: 8),
        ThemeModeIndicator(isSelected: selected),
      ],
    );
  }
}
