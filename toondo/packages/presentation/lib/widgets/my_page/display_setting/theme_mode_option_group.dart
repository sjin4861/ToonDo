import 'package:flutter/material.dart';
import 'package:presentation/widgets/my_page/display_setting/theme_mode_option_tile.dart';

class ThemeModeOptionGroup extends StatelessWidget {
  const ThemeModeOptionGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        ThemeModeOptionTile(
          mode: ThemeMode.light,
          selected: true,
        ),
        SizedBox(width: 8),
        ThemeModeOptionTile(
          mode: ThemeMode.dark,
          selected: false,
        ),
      ],
    );
  }
}
