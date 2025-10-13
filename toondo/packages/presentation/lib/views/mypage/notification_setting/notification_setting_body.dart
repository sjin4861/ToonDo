import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/inputs/app_tip_text.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart';
import 'package:presentation/views/mypage/widget/notification_setting/notification_time_tile.dart';
import 'package:presentation/views/mypage/widget/notification_setting/notification_toggle_tile.dart';
import 'package:provider/provider.dart';

class NotificationSettingBody extends StatelessWidget {
  const NotificationSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationSettingViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v24),
        NotificationToggleTile(
          title: '효과음',
          value: vm.settings.sound,
          onChanged: (_) => vm.toggleSound(),
        ),
        // NotificationToggleTile(
        //   title: '전체알림',
        //   value: vm.settings.all,
        //   onChanged: (_) => vm.toggleAll(),
        // ),
        NotificationToggleTile(
          title: '리마인드 알림',
          value: vm.settings.reminder,
          onChanged: (_) => vm.toggleReminder(),
        ),
        const NotificationTimeTile(),
        SizedBox(height: AppSpacing.v16),
        AppTipText(title: 'TIP ', description: '원하는 시간에 to-do 작성 알림을 받아보세요!'),
      ],
    );
  }
}
