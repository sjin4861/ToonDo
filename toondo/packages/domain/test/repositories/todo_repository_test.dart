import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_data.dart';
import '../mocks/mock_todo_repository.dart';

void main() {
  late MockTodoRepository repository;
  
  setUp(() {
    repository = MockTodoRepository();
  });

  group('TodoRepository 로컬 메서드 테스트', () {
    test('getLocalTodos 메서드는 로컬 할일 리스트를 반환해야 한다', () {
      // Arrange
      final expectedTodos = TestData.createTestTodos();
      when(repository.getLocalTodos()).thenReturn(expectedTodos);
      
      // Act
      final result = repository.getLocalTodos();
      
      // Assert
      expect(result, equals(expectedTodos));
      verify(repository.getLocalTodos()).called(1);
    });
    
    test('createTodo 메서드는 할일을 생성해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test_todo_1');
      when(repository.createTodo(todo)).thenAnswer((_) async => true);
      
      // Act
      final result = await repository.createTodo(todo);
      
      // Assert
      expect(result, isTrue);
      verify(repository.createTodo(todo)).called(1);
    });
    
    test('updateTodo 메서드는 할일을 업데이트해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(
        id: 'test_todo_update',
        title: '업데이트된 할일',
        status: 50.0,
      );
      when(repository.updateTodo(todo)).thenAnswer((_) async {});
      
      // Act
      await repository.updateTodo(todo);
      
      // Assert
      verify(repository.updateTodo(todo)).called(1);
    });
    
    test('deleteTodo 메서드는 할일을 삭제해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test_todo_delete');
      when(repository.deleteTodo(todo)).thenAnswer((_) async {});
      
      // Act
      await repository.deleteTodo(todo);
      
      // Assert
      verify(repository.deleteTodo(todo)).called(1);
    });
  });
  
  group('TodoRepository 원격 메서드 테스트', () {
    test('fetchTodos 메서드는 서버에서 할일 리스트를 가져와야 한다', () async {
      // Arrange
      final expectedTodos = TestData.createTestTodos();
      when(repository.fetchTodos()).thenAnswer((_) async => expectedTodos);
      
      // Act
      final result = await repository.fetchTodos();
      
      // Assert
      expect(result, equals(expectedTodos));
      verify(repository.fetchTodos()).called(1);
    });
    
    test('commitTodos 메서드는 할일 변경사항을 서버에 커밋해야 한다', () async {
      // Arrange
      when(repository.commitTodos()).thenAnswer((_) async => true);
      
      // Act
      final result = await repository.commitTodos();
      
      // Assert
      expect(result, isTrue);
      verify(repository.commitTodos()).called(1);
    });
  });

  group('TodoRepository 상태 및 날짜 업데이트 테스트', () {
    test('updateTodoStatus 메서드는 할일의 상태를 업데이트해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'status_todo');
      const newStatus = 75.0;
      when(repository.updateTodoStatus(todo, newStatus))
          .thenAnswer((_) async {});
      
      // Act
      await repository.updateTodoStatus(todo, newStatus);
      
      // Assert
      verify(repository.updateTodoStatus(todo, newStatus)).called(1);
    });
    
    test('updateTodoDates 메서드는 할일의 날짜를 업데이트해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'dates_todo');
      final newStartDate = DateTime.now().add(const Duration(days: 1));
      final newEndDate = DateTime.now().add(const Duration(days: 3));
      
      when(repository.updateTodoDates(todo, newStartDate, newEndDate))
          .thenAnswer((_) async {});
      
      // Act
      await repository.updateTodoDates(todo, newStartDate, newEndDate);
      
      // Assert
      verify(repository.updateTodoDates(todo, newStartDate, newEndDate)).called(1);
    });
  });

  group('Todo 엔티티 테스트', () {
    test('isDDayTodo 메서드는 D-Day 할일 여부를 정확히 판단해야 한다', () {
      // 1. 당일 할일 (D-Day가 아님)
      final today = DateTime.now();
      final todayTodo = TestData.createTestTodo(
        id: 'today_todo',
        startDate: today,
        endDate: today,
      );
      
      // 2. 여러 날에 걸친 할일 (D-Day 할일)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final dDayTodo = TestData.createTestTodo(
        id: 'dday_todo',
        startDate: today,
        endDate: tomorrow,
      );
      
      // Act & Assert
      expect(todayTodo.isDDayTodo(), isFalse);
      expect(dDayTodo.isDDayTodo(), isTrue);
    });
    
    test('isFinished 메서드는 할일 완료 여부를 정확히 판단해야 한다', () {
      // 1. 진행 중인 할일
      final inProgressTodo = TestData.createTestTodo(
        id: 'in_progress',
        status: 50.0,
      );
      
      // 2. 완료된 할일
      final completedTodo = TestData.createTestTodo(
        id: 'completed',
        status: 100.0,
      );
      
      // Act & Assert
      expect(inProgressTodo.isFinished(), isFalse);
      expect(completedTodo.isFinished(), isTrue);
    });
  });
  
  group('TodoRepository 통합 테스트', () {
    test('fetchTodos 후 로컬에 저장하는 시나리오', () async {
      // Arrange
      final remoteTodos = TestData.createTestTodos(count: 2);
      
      when(repository.fetchTodos()).thenAnswer((_) async => remoteTodos);
      when(repository.getLocalTodos()).thenReturn([]);
      
      // Act - 원격 데이터를 가져온 후 로컬 데이터와 병합하는 시나리오
      final fetchedTodos = await repository.fetchTodos();
      
      // 각 Todo를 로컬에 저장하는 시나리오 (실제로는 이를 처리하는 별도의 메서드가 있을 수 있음)
      for (final todo in fetchedTodos) {
        when(repository.createTodo(todo)).thenAnswer((_) async => true);
        await repository.createTodo(todo);
      }
      
      // Assert
      verify(repository.fetchTodos()).called(1);
      for (final todo in fetchedTodos) {
        verify(repository.createTodo(todo)).called(1);
      }
    });
    
    test('목표와 연결된 할일 관리 시나리오', () async {
      // Arrange - 특정 목표에 연결된 할일들
      const goalId = 'test_goal_123';
      final goalTodos = TestData.createTestTodos(count: 3, goalId: goalId);
      
      when(repository.getLocalTodos()).thenReturn(goalTodos);
      
      // Act & Assert - 목표에 연결된 할일 필터링
      final todos = repository.getLocalTodos();
      final filteredTodos = todos.where((todo) => todo.goalId == goalId).toList();
      
      expect(filteredTodos.length, equals(3));
      expect(filteredTodos.every((todo) => todo.goalId == goalId), isTrue);
      verify(repository.getLocalTodos()).called(1);
    });
  });
}