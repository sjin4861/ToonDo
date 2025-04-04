import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/display_setting/theme_mode_option_group.dart';
import 'package:presentation/widgets/my_page/display_setting/display_setting_title_section.dart';

class DisplaySettingScreen extends StatelessWidget {
  const DisplaySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '화면'),
      backgroundColor: const Color(0xFFFDFDFD),
      body: Padding(
        padding: const EdgeInsets.all(24),
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
