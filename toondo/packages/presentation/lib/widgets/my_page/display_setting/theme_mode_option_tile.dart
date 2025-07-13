import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'theme_mode_indicator.dart';

class ThemeModeOptionTile extends StatelessWidget {
  final ThemeModeType mode;
  final bool selected;

  const ThemeModeOptionTile({
    super.key,
    required this.mode,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final isLight = mode == ThemeModeType.light;

    final backgroundColor =
        isLight ? const Color(0xFFFDFDFD) : const Color(0xFF444444);

    final iconColor =
        isLight ? const Color(0x801C1D1B) : const Color(0xA6FFFFFF);

    return Column(
      children: [
        selected
            ? Container(
              width: 145,
              height: 96,
              padding: const EdgeInsets.all(2),
              // border color
              decoration: BoxDecoration(
                color: const Color(0xFF78B545),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _InnerBox(isLight: isLight, iconColor: iconColor),
            )
            : Container(
              width: 145,
              height: 96,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border:
                    isLight
                        ? Border.all(color: const Color(0xFFD9D9D9), width: 2)
                        : null,
              ),
              child: Center(
                child: Assets.icons.icFace0.svg(
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
        const SizedBox(height: 8),
        Text(
          isLight ? '라이트' : '다크',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        ThemeModeIndicator(isSelected: selected),
      ],
    );
  }
}

class _InnerBox extends StatelessWidget {
  final bool isLight;
  final Color iconColor;

  const _InnerBox({required this.isLight, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isLight ? const Color(0xFFFDFDFD) : const Color(0xFF444444);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Assets.icons.icFace0.svg(
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
