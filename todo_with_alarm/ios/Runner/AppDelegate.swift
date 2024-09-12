import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 알림 권한 요청 처리
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
          print("Error requesting notifications permission: \(error)")
        } else if granted {
          print("Notifications permission granted.")
        } else {
          print("Notifications permission denied.")
        }
      }
    }
    
    // Flutter 플러그인 등록 (Flutter 2.0 이상에서는 자동으로 처리됨)
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 앱이 포그라운드 상태에서도 알림이 오도록 설정
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter, 
    willPresent notification: UNNotification, 
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  // 알림을 클릭했을 때 처리하는 메서드
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter, 
    didReceive response: UNNotificationResponse, 
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}