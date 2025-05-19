import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/display_setting/display_setting_viewmodel.dart';
import 'package:presentation/widgets/my_page/display_setting/theme_mode_option_tile.dart';
import 'package:provider/provider.dart';

class ThemeModeOptionGroup extends StatelessWidget {
  const ThemeModeOptionGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DisplaySettingViewModel>();

    if (!vm.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedMode = vm.currentMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => vm.selectMode(ThemeModeType.light),
          child: ThemeModeOptionTile(
            mode: ThemeModeType.light,
            selected: selectedMode == ThemeModeType.light,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => vm.selectMode(ThemeModeType.dark),
          child: ThemeModeOptionTile(
            mode: ThemeModeType.dark,
            selected: selectedMode == ThemeModeType.dark,
          ),
        ),
      ],
    );
  }
}
