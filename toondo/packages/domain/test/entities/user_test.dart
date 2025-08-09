import 'package:flutter_test/flutter_test.dart';
import 'package:domain/entities/user.dart';

void main() {
  group('User Entity', () {
    group('생성자 테스트', () {
      test('필수 파라미터로 User가 생성되어야 한다', () {
        // Arrange
        final testCreatedAt = DateTime(2024, 1, 1);

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          createdAt: testCreatedAt,
        );

        // Assert
        expect(user.id, equals(1));
        expect(user.loginId, equals('testuser'));
        expect(user.nickname, isNull);
        expect(user.createdAt, equals(testCreatedAt));
      });

      test('모든 파라미터로 User가 생성되어야 한다', () {
        // Arrange
        final testCreatedAt = DateTime(2024, 1, 1);

        // Act
        final user = User(
          id: 123,
          loginId: 'testuser123',
          nickname: '테스트유저',
          createdAt: testCreatedAt,
        );

        // Assert
        expect(user.id, equals(123));
        expect(user.loginId, equals('testuser123'));
        expect(user.nickname, equals('테스트유저'));
        expect(user.createdAt, equals(testCreatedAt));
      });

      test('createdAt이 null이면 현재 시간으로 설정되어야 한다', () {
        // Arrange
        final beforeCall = DateTime.now();

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          // createdAt 생략
        );

        // Arrange
        final afterCall = DateTime.now();

        // Assert
        expect(user.createdAt.isAfter(beforeCall.subtract(Duration(seconds: 1))), isTrue);
        expect(user.createdAt.isBefore(afterCall.add(Duration(seconds: 1))), isTrue);
      });

      test('createdAt이 명시적으로 null로 전달되면 현재 시간으로 설정되어야 한다', () {
        // Arrange
        final beforeCall = DateTime.now();

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          createdAt: null,
        );

        // Arrange
        final afterCall = DateTime.now();

        // Assert
        expect(user.createdAt.isAfter(beforeCall.subtract(Duration(seconds: 1))), isTrue);
        expect(user.createdAt.isBefore(afterCall.add(Duration(seconds: 1))), isTrue);
      });
    });

    group('팩토리 생성자 테스트', () {
      test('팩토리 생성자가 내부 생성자를 올바르게 호출해야 한다', () {
        // Arrange
        final testCreatedAt = DateTime(2024, 1, 1);

        // Act
        final user = User(
          id: 456,
          loginId: 'factorytest',
          nickname: '팩토리테스트',
          createdAt: testCreatedAt,
        );

        // Assert
        expect(user.id, equals(456));
        expect(user.loginId, equals('factorytest'));
        expect(user.nickname, equals('팩토리테스트'));
        expect(user.createdAt, equals(testCreatedAt));
      });
    });

    group('필드 불변성 테스트', () {
      test('생성된 User의 모든 필드는 불변이어야 한다', () {
        // Arrange
        final testCreatedAt = DateTime(2024, 1, 1);
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: '테스트유저',
          createdAt: testCreatedAt,
        );

        // Assert - 모든 필드가 final이므로 컴파일 타임에 확인됨
        expect(user.id, equals(1));
        expect(user.loginId, equals('testuser'));
        expect(user.nickname, equals('테스트유저'));
        expect(user.createdAt, equals(testCreatedAt));
        
        // 필드 변경 시도는 컴파일 에러가 발생하므로 테스트로 확인할 수 없음
        // user.id = 2; // 컴파일 에러
        // user.loginId = 'changed'; // 컴파일 에러
      });
    });

    group('경계값 테스트', () {
      test('음수 ID로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: -1,
          loginId: 'testuser',
        );

        // Assert
        expect(user.id, equals(-1));
      });

      test('0 ID로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 0,
          loginId: 'testuser',
        );

        // Assert
        expect(user.id, equals(0));
      });

      test('매우 큰 ID로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 999999999,
          loginId: 'testuser',
        );

        // Assert
        expect(user.id, equals(999999999));
      });

      test('빈 문자열 loginId로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: '',
        );

        // Assert
        expect(user.loginId, equals(''));
      });

      test('매우 긴 loginId로 User가 생성되어야 한다', () {
        // Arrange
        final longLoginId = 'a' * 1000;

        // Act
        final user = User(
          id: 1,
          loginId: longLoginId,
        );

        // Assert
        expect(user.loginId, equals(longLoginId));
      });

      test('빈 문자열 nickname으로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: '',
        );

        // Assert
        expect(user.nickname, equals(''));
      });

      test('매우 긴 nickname으로 User가 생성되어야 한다', () {
        // Arrange
        final longNickname = '가' * 1000;

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: longNickname,
        );

        // Assert
        expect(user.nickname, equals(longNickname));
      });

      test('과거 날짜 createdAt으로 User가 생성되어야 한다', () {
        // Arrange
        final pastDate = DateTime(1990, 1, 1);

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          createdAt: pastDate,
        );

        // Assert
        expect(user.createdAt, equals(pastDate));
      });

      test('미래 날짜 createdAt으로 User가 생성되어야 한다', () {
        // Arrange
        final futureDate = DateTime(2050, 1, 1);

        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          createdAt: futureDate,
        );

        // Assert
        expect(user.createdAt, equals(futureDate));
      });
    });

    group('특수 문자 테스트', () {
      test('특수 문자가 포함된 loginId로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'test@user#123!',
        );

        // Assert
        expect(user.loginId, equals('test@user#123!'));
      });

      test('유니코드 문자가 포함된 nickname으로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: '테스트유저🎉',
        );

        // Assert
        expect(user.nickname, equals('테스트유저🎉'));
      });

      test('공백이 포함된 nickname으로 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: '테스트 유저',
        );

        // Assert
        expect(user.nickname, equals('테스트 유저'));
      });
    });

    group('null 값 처리 테스트', () {
      test('nickname이 null인 User가 생성되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
          nickname: null,
        );

        // Assert
        expect(user.nickname, isNull);
      });

      test('nickname을 명시하지 않으면 null이 되어야 한다', () {
        // Act
        final user = User(
          id: 1,
          loginId: 'testuser',
        );

        // Assert
        expect(user.nickname, isNull);
      });
    });
  });
}
