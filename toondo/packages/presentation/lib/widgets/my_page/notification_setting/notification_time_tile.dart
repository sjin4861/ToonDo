import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';
import 'package:presentation/widgets/my_page/notification_setting/time_picker/time_picker_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';

class NotificationTimeTile extends StatelessWidget {
  const NotificationTimeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AppNotificationViewModel>();
    final timeText = vm.settings.time;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '리마인드 알림 시간',
        style: AppTypography.h3Regular.copyWith(
          color: AppColors.status100
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeText,
            style: AppTypography.h3Regular.copyWith(
              color: Color(0xFF858584),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing16),
          Icon(Icons.arrow_forward_ios, size: AppDimensions.iconSize16, color: Color(0xFFD9D9D9)),
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
