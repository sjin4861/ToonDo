import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart';
import 'package:provider/provider.dart';
import 'notification_setting_scaffold.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.instance<NotificationSettingViewModel>(),
      child: const NotificationSettingScaffold(),
    );
  }
}
