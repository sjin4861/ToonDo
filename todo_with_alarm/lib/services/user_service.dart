// lib/services/user_service.dart

import 'package:hive/hive.dart';
import 'package:todo_with_alarm/models/user.dart';

class UserService {
  final Box<User> _userBox;

  /// 생성자를 통해 Hive 박스를 주입받습니다.
  /// main.dart에서 `final userService = UserService(userBox);`로 사용
  UserService(this._userBox);

  /// 현재 로그인 중인 사용자(User) 객체를 반환
  /// (여기서는 'currentUser'라는 키로 관리한다고 가정)
  User? getCurrentUser() {
    return _userBox.get('currentUser');
  }

  /// 현재 User 객체를 저장 (갱신)
  /// (Hive에 put)
  Future<void> saveCurrentUser(User user) async {
    await _userBox.put('currentUser', user);
  }

  /// Todo 동기화 시간 업데이트
  Future<void> updateTodoSyncTime(DateTime syncTime) async {
    final user = getCurrentUser();
    if (user == null) {
      // 필요에 따라 새로운 User 생성 로직을 추가하거나, 그냥 return
      return;
    }
    user.lastTodoSyncTime = syncTime;
    await saveCurrentUser(user);
  }

  /// Goal 동기화 시간 업데이트
  Future<void> updateGoalSyncTime(DateTime syncTime) async {
    final user = getCurrentUser();
    if (user == null) return;
    user.lastGoalSyncTime = syncTime;
    await saveCurrentUser(user);
  }

  /// 마지막 Todo 동기화 시각 조회
  DateTime? getLastTodoSyncTime() {
    final user = getCurrentUser();
    return user?.lastTodoSyncTime;
  }

  /// 마지막 Goal 동기화 시각 조회
  DateTime? getLastGoalSyncTime() {
    final user = getCurrentUser();
    return user?.lastGoalSyncTime;
  }

  // -------------------------
  // 아래부터는 슬라임 캐릭터와의 대화를 위해 필요한 예시 메서드들
  // -------------------------

  /// 슬라임 캐릭터와의 대화 로그를 전부 가져오기
  List<String> getConversationLog() {
    final user = getCurrentUser();
    return user?.conversationLog ?? [];
  }

  /// 대화 로그에 새 메시지(문자열)를 추가
  Future<void> addConversationLine(String newLine) async {
    final user = getCurrentUser();
    if (user == null) return;

    // conversationLog가 null이면 빈 리스트로 초기화
    user.conversationLog ??= [];
    user.conversationLog!.add(newLine);

    await saveCurrentUser(user);
  }

  /// 대화 로그를 통째로 교체(필요하다면)
  Future<void> setConversationLog(List<String> newLog) async {
    final user = getCurrentUser();
    if (user == null) return;

    user.conversationLog = newLog;
    await saveCurrentUser(user);
  }

  /// 대화 로그 초기화(삭제)
  Future<void> clearConversationLog() async {
    final user = getCurrentUser();
    if (user == null) return;

    user.conversationLog = [];
    await saveCurrentUser(user);
  }
}
