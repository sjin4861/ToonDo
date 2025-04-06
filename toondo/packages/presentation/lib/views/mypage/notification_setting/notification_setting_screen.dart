import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_time_tile.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_tip_text.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_toggle_tile.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '알림 설정'),
      backgroundColor: const Color(0xFFFDFDFD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationToggleTile(title: '효과음', value: false),
            const NotificationToggleTile(title: '전체알림', value: true),
            const NotificationToggleTile(title: '분석리포트 알림', value: true),
            const NotificationToggleTile(title: '리마인드 알림', value: true),
            const SizedBox(height: 24),
            const NotificationTimeTile(timeText: '03:00'),
            const SizedBox(height: 24),
            const NotificationTipText(),
          ],
        ),
      ),
    );
  }
}
