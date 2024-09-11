class AppNotification {
  String title; // 알림 제목
  String body; // 알림 내용
  DateTime scheduledTime; // 알림이 울릴 시간

  AppNotification({
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  // 남은 시간을 반환하는 함수 (디버깅 용도 또는 UI 표시 용도)
  Duration getRemainingTime() {
    return scheduledTime.difference(DateTime.now());
  }

  // 알림 정보를 문자열로 출력 (디버깅 또는 저장 용도)
  @override
  String toString() {
    return 'Notification(title: $title, body: $body, scheduledTime: $scheduledTime)';
  }
}