import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/entities/status.dart'; // 추가: Goal status 사용

/// 테스트에 사용될 샘플 데이터를 제공하는 클래스
class TestData {
  // 테스트용 상수
  static const String testLoginId = 'testuser123';
  static const String testPassword = 'TestPass123!';
  static const String testNickname = '테스트유저';
  static const String testEmail = 'test@example.com';

  // 테스트용 사용자 객체
  static final User testUser = User(
    id: 1,
    loginId: testLoginId,
    nickname: testNickname,
    points: 0,
  );

  /// 테스트용 사용자 생성
  static User createTestUser({
    int id = 1,
    String name = '테스트 사용자',
    String email = 'test@example.com',
  }) {
    return User(
      id: id,
      loginId: email,
      nickname: name,
      points: 0,
    );
  }

  /// 테스트용 목표 생성
  static Goal createTestGoal({
    String id = 'test-id',
    required String title,
    String icon = 'assets/icons/ic_100point.svg',
    DateTime? startDate,
    DateTime? endDate,
    double progress = 0.0,
    Status status = Status.active,
  }) {
    return Goal(
      id: id,
      name: title,
      icon: icon,
      startDate: startDate ?? DateTime(2025, 1, 1),
      endDate: endDate ?? DateTime(2025, 12, 31),
      progress: progress,
      status: status,
    );
  }

  /// 테스트용 목표 목록 생성
  static List<Goal> createTestGoals() {
    return [
      createTestGoal(id: 'goal-1', title: '목표 1'),
      createTestGoal(id: 'goal-2', title: '목표 2'),
    ];
  }

  /// 테스트용 투두 생성
  static Todo createTestTodo({
    String id = 'test-todo-id',
    String title = '테스트 투두',
    String? goalId,
    DateTime? startDate,
    DateTime? endDate,
    double status = 0.0,
    int importance = 0,
    int urgency = 0,
  }) {
    return Todo(
      id: id,
      title: title,
      goalId: goalId ?? 'goal-1',
      startDate: startDate ?? DateTime(2025, 5, 5),
      endDate: endDate ?? DateTime(2025, 5, 5),
      status: status,
      importance: importance,
      urgency: urgency,
    );
  }

  /// 테스트용 데일리 투두 생성
  static Todo createDailyTodo({
    String id = 'daily-todo-id',
    String title = '데일리 투두',
    String? goalId,
    DateTime? date,
    double status = 0.0,
    int importance = 0,
    int urgency = 0,
  }) {
    final todoDate = date ?? DateTime(2025, 5, 5);
    return Todo(
      id: id,
      title: title,
      goalId: goalId ?? 'goal-1',
      startDate: todoDate,
      endDate: todoDate,
      status: status,
      importance: importance,
      urgency: urgency,
    );
  }

  /// 테스트용 D-Day 투두 생성
  static Todo createDDayTodo({
    String id = 'dday-todo-id',
    String title = 'D-Day 투두',
    String? goalId,
    DateTime? startDate,
    DateTime? endDate,
    double status = 0.0,
    int importance = 0,
    int urgency = 0,
  }) {
    return Todo(
      id: id,
      title: title,
      goalId: goalId ?? 'goal-1',
      startDate: startDate ?? DateTime(2025, 5, 1),
      endDate: endDate ?? DateTime(2025, 5, 10),
      status: status,
      importance: importance,
      urgency: urgency,
    );
  }

  /// 테스트용 투두 목록 생성 (데일리 + D-Day)
  static List<Todo> createTestTodos() {
    return [
      // 데일리 투두
      createDailyTodo(id: 'daily-1', title: '데일리 투두 1', goalId: 'goal-1', importance: 1),
      createDailyTodo(id: 'daily-2', title: '데일리 투두 2', goalId: 'goal-2', urgency: 1),
      
      // D-Day 투두
      createDDayTodo(
        id: 'dday-1', 
        title: 'D-Day 투두 1', 
        goalId: 'goal-1',
        startDate: DateTime(2025, 5, 3),
        endDate: DateTime(2025, 5, 7),
        importance: 1, 
        urgency: 1
      ),
      createDDayTodo(
        id: 'dday-2', 
        title: 'D-Day 투두 2', 
        goalId: 'goal-2',
        startDate: DateTime(2025, 5, 4),
        endDate: DateTime(2025, 5, 10)
      ),
    ];
  }
}