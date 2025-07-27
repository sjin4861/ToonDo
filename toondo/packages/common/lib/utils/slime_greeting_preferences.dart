/// 슬라임 인사말과 관련된 상태 관리 클래스
class SlimeGreetingManager {
  static DateTime? _lastGreetingDate;
  static bool _dailyGreetingShown = false;
  static int _loginCount = 0;
  static DateTime? _lastAccessTime;

  /// 오늘 처음 접속인지 확인
  static bool isFirstLoginToday() {
    final today = DateTime.now();
    if (_lastGreetingDate == null) {
      return true;
    }
    
    final lastDate = _lastGreetingDate!;
    return today.year != lastDate.year ||
           today.month != lastDate.month ||
           today.day != lastDate.day;
  }

  /// 오늘의 첫 인사말 표시 완료 마킹
  static void markTodayGreetingShown() {
    _lastGreetingDate = DateTime.now();
    _dailyGreetingShown = true;
  }

  /// 로그인 횟수 증가
  static int incrementLoginCount() {
    _loginCount++;
    return _loginCount;
  }

  /// 총 로그인 횟수 가져오기
  static int getLoginCount() {
    return _loginCount;
  }

  /// 오늘 인사말이 표시되었는지 확인
  static bool isDailyGreetingShown() {
    if (!isFirstLoginToday()) {
      return _dailyGreetingShown;
    }
    return false;
  }

  /// 마지막 접속 시간 업데이트
  static void updateLastAccessTime() {
    _lastAccessTime = DateTime.now();
  }

  /// 마지막 접속 시간 가져오기
  static DateTime? getLastAccessTime() {
    return _lastAccessTime;
  }

  /// 하루가 지났는지 확인
  static bool hasOneDayPassed() {
    if (_lastAccessTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(_lastAccessTime!);
    return difference.inDays >= 1;
  }

  /// 접속 후 오랜 시간이 지났는지 확인 (2시간 이상)
  static bool hasLongTimePassed() {
    if (_lastAccessTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(_lastAccessTime!);
    return difference.inHours >= 2;
  }

  /// 초기화 - 앱 시작 시 호출
  static void initialize() {
    updateLastAccessTime();
  }
}
