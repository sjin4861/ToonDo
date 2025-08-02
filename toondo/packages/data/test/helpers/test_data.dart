import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/entities/user.dart';

class TestData {
  // 테스트용 상수
  static const String testLoginId = 'testuser123';
  static const String testPassword = 'TestPass123!';
  static const String testNickname = '테스트유저';
  static const String testEmail = 'test@example.com';

  // 테스트용 사용자 생성
  static User createTestUser({
    int id = 1,
    String? loginId,
    String? nickname = '테스트 사용자',
  }) {
    return User(
      id: id,
      loginId: loginId ?? testLoginId,
      nickname: nickname,
    );
  }

  // 테스트용 목표 생성 (ID만 변경하여 여러 개의 목표 생성 가능)
  static Goal createTestGoal({
    required String id,
    String name = '테스트 목표',
    String? icon,
    double progress = 0.0,
    DateTime? startDate,
    DateTime? endDate,
    Status status = Status.active,
  }) {
    return Goal(
      id: id,
      name: name,
      icon: icon,
      progress: progress,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      status: status,
    );
  }

  // 테스트용 목표 목록 생성
  static List<Goal> createTestGoals({int count = 3}) {
    return List.generate(
      count,
      (index) => createTestGoal(
        id: 'goal_$index',
        name: '테스트 목표 $index',
        progress: index * 0.2,
      ),
    );
  }
  
  // 테스트용 할일 생성
  static Todo createTestTodo({
    required String id,
    String title = '테스트 할일',
    String? goalId,
    double status = 0.0,
    String comment = '',
    DateTime? startDate,
    DateTime? endDate,
    int urgency = 1,
    int importance = 1,
  }) {
    return Todo(
      id: id,
      title: title,
      goalId: goalId,
      status: status,
      comment: comment,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 1)),
      urgency: urgency,
      importance: importance,
    );
  }
  
  // 테스트용 할일 목록 생성
  static List<Todo> createTestTodos({int count = 3, String? goalId}) {
    return List.generate(
      count,
      (index) => createTestTodo(
        id: 'todo_$index',
        title: '테스트 할일 $index',
        goalId: goalId,
        status: index * 25.0,
        urgency: (index % 2) + 1,
        importance: (index % 2) + 1,
      ),
    );
  }
}