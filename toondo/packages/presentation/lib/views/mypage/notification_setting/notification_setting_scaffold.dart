import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_time_tile.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_tip_text.dart';
import 'package:presentation/widgets/my_page/notification_setting/notification_toggle_tile.dart';
import 'package:provider/provider.dart';

class NotificationSettingScaffold extends StatelessWidget {
  const NotificationSettingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationSettingViewModel>();

    return Scaffold(
      appBar: CustomAppBar(title: '알림 설정'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationToggleTile(
              title: '효과음',
              value: vm.settings.sound,
              onChanged: (_) => vm.toggleSound(),
            ),
            NotificationToggleTile(
              title: '전체알림',
              value: vm.settings.all,
              onChanged: (_) => vm.toggleAll(),
            ),
            NotificationToggleTile(
              title: '분석리포트 알림',
              value: vm.settings.report,
              onChanged: (_) => vm.toggleReport(),
            ),
            NotificationToggleTile(
              title: '리마인드 알림',
              value: vm.settings.reminder,
              onChanged: (_) => vm.toggleReminder(),
            ),
            const SizedBox(height: 24),
            NotificationTimeTile(),
            const SizedBox(height: 24),
            const NotificationTipText(),
          ],
        ),
      ),
    );
  }
}
