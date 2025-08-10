import 'package:flutter_test/flutter_test.dart';
import 'package:domain/entities/todo.dart';

void main() {
  group('Todo Entity', () {
    late DateTime testStartDate;
    late DateTime testEndDate;
    late DateTime sameDate;

    setUp(() {
      testStartDate = DateTime(2024, 1, 1);
      testEndDate = DateTime(2024, 1, 2);
      sameDate = DateTime(2024, 1, 1);
    });

    group('생성자 테스트', () {
      test('필수 파라미터로 Todo가 생성되어야 한다', () {
        // Act
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Assert
        expect(todo.id, equals('test-id'));
        expect(todo.title, equals('테스트 할일'));
        expect(todo.startDate, equals(testStartDate));
        expect(todo.endDate, equals(testEndDate));
        expect(todo.goalId, isNull);
        expect(todo.status, equals(0.0));
        expect(todo.comment, equals(''));
        expect(todo.eisenhower, equals(0));
      });

      test('모든 파라미터로 Todo가 생성되어야 한다', () {
        // Act
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          goalId: 'goal-123',
          status: 1.0,
          comment: '테스트 코멘트',
          eisenhower: 2,
        );

        // Assert
        expect(todo.id, equals('test-id'));
        expect(todo.title, equals('테스트 할일'));
        expect(todo.startDate, equals(testStartDate));
        expect(todo.endDate, equals(testEndDate));
        expect(todo.goalId, equals('goal-123'));
        expect(todo.status, equals(1.0));
        expect(todo.comment, equals('테스트 코멘트'));
        expect(todo.eisenhower, equals(2));
      });
    });

    group('isDDayTodo 메서드 테스트', () {
      test('시작일과 종료일이 다르면 D-Day 할일이어야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(todo.isDDayTodo(), isTrue);
      });

      test('시작일과 종료일이 같으면 D-Day 할일이 아니어야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: sameDate,
          endDate: sameDate,
        );

        // Act & Assert
        expect(todo.isDDayTodo(), isFalse);
      });

      test('시작일과 종료일의 시간이 다르지만 같은 날짜면 D-Day 할일이 아니어야 한다', () {
        // Arrange
        final startDate = DateTime(2024, 1, 1, 9, 0, 0);
        final endDate = DateTime(2024, 1, 1, 18, 0, 0);
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: startDate,
          endDate: endDate,
        );

        // Act & Assert
        expect(todo.isDDayTodo(), isFalse);
      });
    });

    group('isFinished 메서드 테스트', () {
      test('status가 1.0이면 완료된 할일이어야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 1.0,
        );

        // Act & Assert
        expect(todo.isFinished(), isTrue);
      });

      test('status가 0.0이면 완료되지 않은 할일이어야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 0.0,
        );

        // Act & Assert
        expect(todo.isFinished(), isFalse);
      });

      test('status가 0.5이면 완료되지 않은 할일이어야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 0.5,
        );

        // Act & Assert
        expect(todo.isFinished(), isFalse);
      });
    });

    group('getToggledStatus 메서드 테스트', () {
      test('status가 0.0이면 1.0을 반환해야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 0.0,
        );

        // Act & Assert
        expect(todo.getToggledStatus(), equals(1.0));
      });

      test('status가 1.0이면 0.0을 반환해야 한다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 1.0,
        );

        // Act & Assert
        expect(todo.getToggledStatus(), equals(0.0));
      });

      test('status가 0.5이면 0.0을 반환해야 한다 (1.0이 아닌 모든 값은 0.0으로)', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          status: 0.5,
        );

        // Act & Assert
        expect(todo.getToggledStatus(), equals(0.0));
      });
    });

    group('Eisenhower 매트릭스 테스트', () {
      test('eisenhower 값이 0이면 중요하지 않고 긴급하지 않은 작업이다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: 0,
        );

        // Act & Assert
        expect(todo.eisenhower, equals(0));
      });

      test('eisenhower 값이 1이면 중요하지만 긴급하지 않은 작업이다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: 1,
        );

        // Act & Assert
        expect(todo.eisenhower, equals(1));
      });

      test('eisenhower 값이 2이면 긴급하지만 중요하지 않은 작업이다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: 2,
        );

        // Act & Assert
        expect(todo.eisenhower, equals(2));
      });

      test('eisenhower 값이 3이면 중요하고 긴급한 작업이다', () {
        // Arrange
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: 3,
        );

        // Act & Assert
        expect(todo.eisenhower, equals(3));
      });
    });

    group('정적 ID 생성 테스트', () {
      test('Todo.currentId가 올바르게 초기화되어야 한다', () {
        // Assert
        expect(Todo.currentId, equals(1));
      });

      test('Todo.currentId는 수정 가능해야 한다', () {
        // Arrange
        final originalId = Todo.currentId;

        // Act
        Todo.currentId = 100;

        // Assert
        expect(Todo.currentId, equals(100));

        // Cleanup
        Todo.currentId = originalId;
      });
    });

    group('경계값 테스트', () {
      test('빈 문자열 title로 Todo가 생성되어야 한다', () {
        // Act
        final todo = Todo(
          id: 'test-id',
          title: '',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Assert
        expect(todo.title, equals(''));
      });

      test('매우 긴 title로 Todo가 생성되어야 한다', () {
        // Arrange
        final longTitle = 'a' * 1000;

        // Act
        final todo = Todo(
          id: 'test-id',
          title: longTitle,
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Assert
        expect(todo.title, equals(longTitle));
      });

      test('음수 eisenhower 값으로 Todo가 생성되어야 한다', () {
        // Act
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: -1,
        );

        // Assert
        expect(todo.eisenhower, equals(-1));
      });

      test('큰 eisenhower 값으로 Todo가 생성되어야 한다', () {
        // Act
        final todo = Todo(
          id: 'test-id',
          title: '테스트 할일',
          startDate: testStartDate,
          endDate: testEndDate,
          eisenhower: 100,
        );

        // Assert
        expect(todo.eisenhower, equals(100));
      });
    });
  });
}
