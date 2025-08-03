import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/setting/app_theme_radio_button.dart';
import 'package:presentation/viewmodels/my_page/display_setting/display_setting_viewmodel.dart';
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
        AppThemeRadioButton(
          type: ThemeModeType.light,
          isSelected: selectedMode == ThemeModeType.light,
          onTap: () => vm.selectMode(ThemeModeType.light),
        ),
        const SizedBox(width: 8),
        AppThemeRadioButton(
          type: ThemeModeType.dark,
          isSelected: selectedMode == ThemeModeType.dark,
          onTap: () => vm.selectMode(ThemeModeType.dark),
        ),
      ],
    );
  }
}
