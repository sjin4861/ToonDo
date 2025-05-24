import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';
import 'package:presentation/widgets/my_page/notification_setting/time_picker/time_picker_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';
import 'package:presentation/widgets/my_page/notification_setting/time_picker/time_picker_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';
import 'package:presentation/widgets/my_page/notification_setting/time_picker/time_picker_bottom_sheet.dart';
import 'package:provider/provider.dart';

class NotificationTimeTile extends StatelessWidget {
  const NotificationTimeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AppNotificationViewModel>();
    final timeText = vm.settings.time;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '리마인드 알림 시간',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: textColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 16, color: IconTheme.of(context).color),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => GetIt.instance<TimePickerViewModel>(),
            child: const TimePickerBottomSheet(),
          ),
        );
      },
    );
  }
}
