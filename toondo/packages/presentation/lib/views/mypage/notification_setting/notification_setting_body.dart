import 'dart:io';
import 'package:common/notification/exact_alarm_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/components/inputs/app_tip_text.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart';
import 'package:presentation/views/mypage/widget/notification_setting/notification_time_tile.dart';
import 'package:presentation/views/mypage/widget/notification_setting/notification_toggle_tile.dart';
import 'package:provider/provider.dart';

class NotificationSettingBody extends StatelessWidget {
  const NotificationSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationSettingViewModel>();
    final appVM = context.watch<AppNotificationViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v24),
        NotificationToggleTile(
          title: '효과음',
          value: vm.settings.sound,
          onChanged: (_) => vm.toggleSound(),
        ),
        NotificationToggleTile(
          title: '리마인드 알림',
          value: vm.settings.reminder,
          onChanged: (next) => _onToggleReminder(context, next, appVM),
        ),
        const NotificationTimeTile(),
        SizedBox(height: AppSpacing.v16),
        const AppTipText(
          title: 'TIP ',
          description: '원하는 시간에 to-do 작성 알림을 받아보세요!',
        ),
      ],
    );
  }
}


Future<void> _onToggleReminder(
    BuildContext context,
    bool next,
    AppNotificationViewModel appVM,
    ) async {
  final settings = appVM.settings;

  if (next == false) {
    await appVM.update(settings.copyWith(reminder: false));
    return;
  }

  var perm = await Permission.notification.status;
  if (!perm.isGranted) {
    perm = await Permission.notification.request();
  }

  if (!perm.isGranted) {
    final go = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.v8),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F0D9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_active_outlined,
                    color: const Color(0xFF78B545), size: 28.w),
              ),
              SizedBox(height: AppSpacing.v12),
              Text(
                '알림 권한이 꺼져 있어요',
                textAlign: TextAlign.center,
                style: AppTypography.h2Bold.copyWith(letterSpacing: 0.15),
              ),
              SizedBox(height: AppSpacing.v8),
              Text(
                '정확한 리마인드 알림을 받으려면 알림 권한이 필요해요.\n설정으로 이동할까요?',
                textAlign: TextAlign.center,
                style: AppTypography.body2Regular.copyWith(
                  color: const Color(0xFF535353),
                  letterSpacing: 0.15,
                ),
              ),
              SizedBox(height: AppSpacing.v16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.status100,
                        side: const BorderSide(color: Color(0xFFD9D9D9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('취소', style: AppTypography.body2SemiBold),
                    ),
                  ),
                  SizedBox(width: AppSpacing.h12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('설정 열기',
                          style: AppTypography.body2SemiBold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;

    if (go) {
      if (Platform.isAndroid) {
        await openAppNotificationSettings();
      } else {
        await openAppSettings(); // iOS/기타
      }
    }
    return; // 권한 받을 때까지 토글 켜지지 않음
  }

  if (Platform.isAndroid) {
    final goExact = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.v8),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F0D9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.alarm_on_outlined,
                    color: const Color(0xFF78B545), size: 28.w),
              ),
              SizedBox(height: AppSpacing.v12),
              Text(
                '정확한 알람 허용',
                textAlign: TextAlign.center,
                style: AppTypography.h2Bold.copyWith(letterSpacing: 0.15),
              ),
              SizedBox(height: AppSpacing.v8),
              Text(
                '정확한 알람이 꺼져 있으면 알림 시간이 지연될 수 있어요.\n설정에서 "정확한 알람"을 허용하시겠어요?',
                textAlign: TextAlign.center,
                style: AppTypography.body2Regular.copyWith(
                  color: const Color(0xFF535353),
                  letterSpacing: 0.15,
                ),
              ),
              SizedBox(height: AppSpacing.v16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.status100,
                        side: const BorderSide(color: Color(0xFFD9D9D9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('건너뛰기',
                          style: AppTypography.body2SemiBold),
                    ),
                  ),
                  SizedBox(width: AppSpacing.h12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('설정 열기',
                          style: AppTypography.body2SemiBold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;

    if (goExact) {
      await openExactAlarmSettings();
    }
  }

  await appVM.update(settings.copyWith(all: true, reminder: true));
}
