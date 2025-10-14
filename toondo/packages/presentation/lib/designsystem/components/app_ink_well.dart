import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
import 'package:provider/provider.dart';

class AppInkWell extends StatelessWidget {
  const AppInkWell({super.key, this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final feedbackOn = context.select<AppNotificationViewModel, bool>(
      (vm) => vm.settings.all && vm.settings.sound,
    );
    return InkWell(enableFeedback: feedbackOn, onTap: onTap, child: child);
  }
}
