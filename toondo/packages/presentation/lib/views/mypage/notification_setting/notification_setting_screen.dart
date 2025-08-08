import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/mypage/notification_setting/notification_setting_body.dart';
import 'package:provider/provider.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.instance<NotificationSettingViewModel>(),
      child: BaseScaffold(title: '소리/알림', body: NotificationSettingBody()),
    );
  }
}
