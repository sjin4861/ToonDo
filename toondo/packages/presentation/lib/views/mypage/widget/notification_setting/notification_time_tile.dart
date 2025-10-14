import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';
import 'package:presentation/views/mypage/widget/notification_setting/time_picker_bottom_sheet.dart';

class NotificationTimeTile extends StatelessWidget {
  const NotificationTimeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotificationViewModel>();
    final timeText = app.settings.time;
    final reminderEnabled = app.settings.all && app.settings.reminder;

    void _openPicker() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ChangeNotifierProvider(
          create: (_) => GetIt.instance<TimePickerViewModel>(),
          child: const TimePickerBottomSheet(),
        ),
      );
    }

    void _warnTurnOn() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리마인드 알림을 먼저 켜주세요.')),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: reminderEnabled, // 시각적으로도 비활성화 표현
      title: Text(
        '리마인드 알림 시간',
        style: AppTypography.h3Regular.copyWith(color: AppColors.status100),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeText,
            style: AppTypography.h3Regular.copyWith(color: const Color(0xFF858584)),
          ),
          SizedBox(width: AppSpacing.h12),
        ],
      ),
      onTap: () {
        if (!reminderEnabled) {
          _warnTurnOn();
          return;
        }
        _openPicker();
      },
    );
  }
}
