import 'package:flutter_test/flutter_test.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';

void main() {
  group('Goal Entity', () {
    late DateTime testStartDate;
    late DateTime testEndDate;

    setUp(() {
      testStartDate = DateTime(2024, 1, 1);
      testEndDate = DateTime(2024, 12, 31);
    });

    group('생성자 테스트', () {
      test('필수 파라미터로 Goal이 생성되어야 한다', () {
        // Act
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Assert
        expect(goal.id, equals('test-id'));
        expect(goal.name, equals('테스트 목표'));
        expect(goal.startDate, equals(testStartDate));
        expect(goal.endDate, equals(testEndDate));
        expect(goal.icon, isNull);
        expect(goal.progress, equals(0.0));
        expect(goal.status, equals(Status.active));
      });

      test('모든 파라미터로 Goal이 생성되어야 한다', () {
        // Act
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          icon: 'test_icon.png',
          progress: 75.5,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.completed,
        );

        // Assert
        expect(goal.id, equals('test-id'));
        expect(goal.name, equals('테스트 목표'));
        expect(goal.icon, equals('test_icon.png'));
        expect(goal.progress, equals(75.5));
        expect(goal.startDate, equals(testStartDate));
        expect(goal.endDate, equals(testEndDate));
        expect(goal.status, equals(Status.completed));
      });
    });

    group('copyWith 메서드 테스트', () {
      late Goal originalGoal;

      setUp(() {
        originalGoal = Goal(
          id: 'original-id',
          name: '원본 목표',
          icon: 'original_icon.png',
          progress: 50.0,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );
      });

      test('아무 파라미터도 전달하지 않으면 동일한 Goal이 반환되어야 한다', () {
        // Act
        final copiedGoal = originalGoal.copyWith();

        // Assert
        expect(copiedGoal.id, equals(originalGoal.id));
        expect(copiedGoal.name, equals(originalGoal.name));
        expect(copiedGoal.icon, equals(originalGoal.icon));
        expect(copiedGoal.progress, equals(originalGoal.progress));
        expect(copiedGoal.startDate, equals(originalGoal.startDate));
        expect(copiedGoal.endDate, equals(originalGoal.endDate));
        expect(copiedGoal.status, equals(originalGoal.status));
        expect(copiedGoal, isNot(same(originalGoal))); // 다른 인스턴스여야 함
      });

      test('특정 필드만 변경하여 복사되어야 한다', () {
        // Act
        final copiedGoal = originalGoal.copyWith(
          name: '변경된 목표',
          progress: 75.0,
          status: Status.completed,
        );

        // Assert
        expect(copiedGoal.id, equals(originalGoal.id)); // 변경되지 않음
        expect(copiedGoal.name, equals('변경된 목표')); // 변경됨
        expect(copiedGoal.icon, equals(originalGoal.icon)); // 변경되지 않음
        expect(copiedGoal.progress, equals(75.0)); // 변경됨
        expect(copiedGoal.startDate, equals(originalGoal.startDate)); // 변경되지 않음
        expect(copiedGoal.endDate, equals(originalGoal.endDate)); // 변경되지 않음
        expect(copiedGoal.status, equals(Status.completed)); // 변경됨
      });

      test('모든 필드를 변경하여 복사되어야 한다', () {
        // Arrange
        final newStartDate = DateTime(2025, 1, 1);
        final newEndDate = DateTime(2025, 12, 31);

        // Act
        final copiedGoal = originalGoal.copyWith(
          id: 'new-id',
          name: '새로운 목표',
          icon: 'new_icon.png',
          progress: 100.0,
          startDate: newStartDate,
          endDate: newEndDate,
          status: Status.givenUp,
        );

        // Assert
        expect(copiedGoal.id, equals('new-id'));
        expect(copiedGoal.name, equals('새로운 목표'));
        expect(copiedGoal.icon, equals('new_icon.png'));
        expect(copiedGoal.progress, equals(100.0));
        expect(copiedGoal.startDate, equals(newStartDate));
        expect(copiedGoal.endDate, equals(newEndDate));
        expect(copiedGoal.status, equals(Status.givenUp));
      });
    });

    group('Goal.empty 팩토리 테스트', () {
      test('빈 Goal이 올바르게 생성되어야 한다', () {
        // Act
        final emptyGoal = Goal.empty();

        // Assert
        expect(emptyGoal.id, equals('-1'));
        expect(emptyGoal.name, equals('목표 미설정'));
        expect(emptyGoal.icon, equals('assets/icons/ic_help-circle.svg'));
        expect(emptyGoal.progress, equals(0.0));
        expect(emptyGoal.status, equals(Status.active));
        expect(emptyGoal.startDate, isA<DateTime>());
        expect(emptyGoal.endDate, isA<DateTime>());
      });

      test('빈 Goal의 시작일과 종료일이 현재 시간이어야 한다', () {
        // Arrange
        final beforeCall = DateTime.now();

        // Act
        final emptyGoal = Goal.empty();

        // Arrange
        final afterCall = DateTime.now();

        // Assert
        expect(emptyGoal.startDate.isAfter(beforeCall.subtract(Duration(seconds: 1))), isTrue);
        expect(emptyGoal.startDate.isBefore(afterCall.add(Duration(seconds: 1))), isTrue);
        // TODO: '마감일 없이 할래요' 기능 - Goal.empty()의 endDate가 null이 될 수 있으므로 테스트 수정
        expect(emptyGoal.endDate?.isAfter(beforeCall.subtract(Duration(seconds: 1))) ?? false, isTrue);
        expect(emptyGoal.endDate?.isBefore(afterCall.add(Duration(seconds: 1))) ?? false, isTrue);
      });
    });

    group('equals 연산자 테스트', () {
      test('동일한 값을 가진 Goal들은 같아야 한다 (ID 제외)', () {
        // Arrange
        final goal1 = Goal(
          id: 'different-id-1',
          name: '동일한 목표',
          icon: 'same_icon.png',
          progress: 50.0,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );

        final goal2 = Goal(
          id: 'different-id-2', // ID가 다름
          name: '동일한 목표',
          icon: 'same_icon.png',
          progress: 50.0,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );

        // Act & Assert
        expect(goal1, equals(goal2)); // ID 제외하고 비교
      });

      test('다른 값을 가진 Goal들은 달라야 한다', () {
        // Arrange
        final goal1 = Goal(
          id: 'same-id',
          name: '목표 1',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        final goal2 = Goal(
          id: 'same-id',
          name: '목표 2', // 이름이 다름
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(goal1, isNot(equals(goal2)));
      });

      test('동일한 인스턴스는 같아야 한다', () {
        // Arrange
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(goal, equals(goal));
      });

      test('null과 비교하면 다르다', () {
        // Arrange
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(goal, isNot(equals(null)));
      });

      test('다른 타입과 비교하면 다르다', () {
        // Arrange
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(goal, isNot(equals('문자열')));
        expect(goal, isNot(equals(123)));
      });
    });

    group('hashCode 테스트', () {
      test('동일한 값을 가진 Goal들은 같은 hashCode를 가져야 한다 (ID 제외)', () {
        // Arrange
        final goal1 = Goal(
          id: 'different-id-1',
          name: '동일한 목표',
          icon: 'same_icon.png',
          progress: 50.0,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );

        final goal2 = Goal(
          id: 'different-id-2', // ID가 다름
          name: '동일한 목표',
          icon: 'same_icon.png',
          progress: 50.0,
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );

        // Act & Assert
        expect(goal1.hashCode, equals(goal2.hashCode));
      });

      test('다른 값을 가진 Goal들은 다른 hashCode를 가져야 한다', () {
        // Arrange
        final goal1 = Goal(
          id: 'same-id',
          name: '목표 1',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        final goal2 = Goal(
          id: 'same-id',
          name: '목표 2', // 이름이 다름
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        expect(goal1.hashCode, isNot(equals(goal2.hashCode)));
      });
    });

    group('Status 변경 테스트', () {
      test('goal의 status는 변경 가능해야 한다', () {
        // Arrange
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
          status: Status.active,
        );

        // Act
        goal.status = Status.completed;

        // Assert
        expect(goal.status, equals(Status.completed));
      });

      test('모든 Status 값으로 설정 가능해야 한다', () {
        // Arrange
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Act & Assert
        goal.status = Status.active;
        expect(goal.status, equals(Status.active));

        goal.status = Status.completed;
        expect(goal.status, equals(Status.completed));

        goal.status = Status.givenUp;
        expect(goal.status, equals(Status.givenUp));

        goal.status = Status.inProgress;
        expect(goal.status, equals(Status.inProgress));
      });
    });

    group('경계값 테스트', () {
      test('빈 문자열 name으로 Goal이 생성되어야 한다', () {
        // Act
        final goal = Goal(
          id: 'test-id',
          name: '',
          startDate: testStartDate,
          endDate: testEndDate,
        );

        // Assert
        expect(goal.name, equals(''));
      });

      test('음수 progress 값으로 Goal이 생성되어야 한다', () {
        // Act
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
          progress: -10.0,
        );

        // Assert
        expect(goal.progress, equals(-10.0));
      });

      test('100을 초과하는 progress 값으로 Goal이 생성되어야 한다', () {
        // Act
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: testStartDate,
          endDate: testEndDate,
          progress: 150.0,
        );

        // Assert
        expect(goal.progress, equals(150.0));
      });

      test('시작일이 종료일보다 늦어도 Goal이 생성되어야 한다', () {
        // Arrange
        final laterStartDate = DateTime(2024, 12, 31);
        final earlierEndDate = DateTime(2024, 1, 1);

        // Act
        final goal = Goal(
          id: 'test-id',
          name: '테스트 목표',
          startDate: laterStartDate,
          endDate: earlierEndDate,
        );

        // Assert
        expect(goal.startDate, equals(laterStartDate));
        expect(goal.endDate, equals(earlierEndDate));
      });
    });
  });
}
