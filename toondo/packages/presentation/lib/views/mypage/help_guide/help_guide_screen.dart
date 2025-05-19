import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/help_guide/help_guide_app_version_tile.dart';
import 'package:presentation/widgets/my_page/help_guide/help_guide_setting_tile.dart';

class HelpGuideScreen extends StatelessWidget {
  const HelpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '이용안내'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HelpGuideAppVersionTile(),
            HelpGuideSettingTile(title: '이용약관'),
            HelpGuideSettingTile(title: '앱 리뷰 남기기'),
            HelpGuideSettingTile(title: '개인정보 처리방침'),
          ],
        ),
      )
    );
  }
}
