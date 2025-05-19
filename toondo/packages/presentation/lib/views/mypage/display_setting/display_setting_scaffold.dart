import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/display_setting/display_setting_title_section.dart';
import 'package:presentation/widgets/my_page/display_setting/theme_mode_option_group.dart';

class DisplaySettingScaffold extends StatelessWidget {
  const DisplaySettingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '화면'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DisplaySettingTitleSection(),
            SizedBox(height: 24),
            ThemeModeOptionGroup(),
          ],
        ),
      ),
    );
  }
}
