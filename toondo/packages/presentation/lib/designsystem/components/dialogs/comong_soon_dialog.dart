import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class ComingSoonDialog {
  /// 간편 호출: ComingSoonDialog.show(context);
  static Future<void> show(
      BuildContext context, {
        String title = '준비중입니다',
        String message = '해당 기능은 곧 제공될 예정이에요 😊',
        String confirmText = '확인',
        bool barrierDismissible = true,
        VoidCallback? onConfirmed,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => _ComingSoonAlert(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirmed: onConfirmed,
      ),
    );
  }

  /// 스낵바 버전: 빠르게 안내만 하고 싶을 때
  static void showSnackBar(
      BuildContext context, {
        String message = '준비중입니다',
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTypography.body2Regular.copyWith(color: Colors.white),
          ),
          duration: duration,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _ComingSoonAlert extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback? onConfirmed;

  const _ComingSoonAlert({
    required this.title,
    required this.message,
    required this.confirmText,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
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
              child: const Icon(Icons.hourglass_empty, color: Color(0xFF78B545)),
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.h2Bold.copyWith(letterSpacing: 0.15),
            ),
            SizedBox(height: AppSpacing.v8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body2Regular.copyWith(
                color: const Color(0xFF535353),
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: AppSpacing.v16),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green500,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 52.w),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmed?.call();
                },
                child: Text(
                  confirmText,
                  style: AppTypography.body2SemiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
