// lib/services/user_service.dart

import 'package:hive/hive.dart';

class UserService {
  /// userBox를 통해 마지막 동기화 시각을 업데이트합니다.
  Future<void> updateTodoSyncTime(DateTime syncTime) async {
    // main.dart에서 이미 'user' 박스를 열어두었으므로, 여기서 바로 사용합니다.
    final Box userBox = Hive.box('user'); // 타입을 지정하지 않아도 됨 (또는 Box<dynamic>로 사용)
    await userBox.put('lastTodoSyncTime', syncTime);
  }
  
  /// Goal 동기화 시간 저장 (신규)
  Future<void> updateGoalSyncTime(DateTime syncTime) async {
    final Box userBox = Hive.box('user');
    await userBox.put('lastGoalSyncTime', syncTime);
  }

  /// 마지막 Todo 동기화 시각 조회
  DateTime? getLastTodoSyncTime() {
    final Box userBox = Hive.box('user');
    return userBox.get('lastTodoSyncTime');
  }

  /// (필요하다면) 마지막 Goal 동기화 시각 조회
  DateTime? getLastGoalSyncTime() {
    final Box userBox = Hive.box('user');
    return userBox.get('lastGoalSyncTime');
  }
}
