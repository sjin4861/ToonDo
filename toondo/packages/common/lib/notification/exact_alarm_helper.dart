import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String?> _packageName() async {
  if (!Platform.isAndroid) return null;
  final info = await PackageInfo.fromPlatform();
  return info.packageName;
}

/// 정확한 알람 권한 화면 열기 (미지원 기기면 앱 상세로 폴백)
Future<void> openExactAlarmSettings() async {
  if (!Platform.isAndroid) return;
  try {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  } catch (_) {
    await openAppDetailsSettings();
  }
}

/// 이 앱의 알림 설정 화면
Future<void> openAppNotificationSettings() async {
  if (!Platform.isAndroid) return;
  final pkg = await _packageName();
  if (pkg == null) return;

  try {
    final intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      arguments: {
        'android.provider.extra.APP_PACKAGE': pkg, // 신버전 키
        'app_package': pkg,                        // 구버전 호환
      },
    );
    await intent.launch();
  } catch (_) {
    await openAppDetailsSettings();
  }
}

/// 앱 상세 설정 (최후 폴백)
Future<void> openAppDetailsSettings() async {
  if (!Platform.isAndroid) return;
  final pkg = await _packageName();
  if (pkg == null) return;

  final intent = AndroidIntent(
    action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
    data: 'package:$pkg',
    flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();
}
