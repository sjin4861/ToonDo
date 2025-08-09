import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/user/get_user.dart';
import 'package:domain/entities/user.dart';
import '../../mocks/mock_user_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  group('GetUserUseCase', () {
    test('사용자 정보가 성공적으로 반환되어야 한다', () async {
      // Arrange
      final user = TestData.createTestUser(
        id: 123,
        loginId: 'testuser',
        nickname: 'testuser',
      );
      when(mockRepository.getUser()).thenAnswer((_) async => user);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(user));
      expect(result.id, equals(123));
      expect(result.nickname, equals('testuser'));
      expect(result.loginId, equals('testuser'));
      verify(mockRepository.getUser()).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      when(mockRepository.getUser()).thenThrow(Exception('사용자 조회 실패'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(mockRepository.getUser()).called(1);
    });

    test('매번 호출할 때마다 Repository를 호출해야 한다', () async {
      // Arrange
      final user = TestData.createTestUser(id: 1);
      when(mockRepository.getUser()).thenAnswer((_) async => user);

      // Act
      await useCase.call();
      await useCase.call();
      await useCase.call();

      // Assert
      verify(mockRepository.getUser()).called(3);
    });

    test('사용자 정보의 모든 필드가 올바르게 반환되어야 한다', () async {
      // Arrange
      final user = TestData.createTestUser(
        id: 456,
        loginId: 'kim',
        nickname: '김철수',
      );
      when(mockRepository.getUser()).thenAnswer((_) async => user);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.id, equals(456));
      expect(result.nickname, equals('김철수'));
      expect(result.loginId, equals('kim'));
      verify(mockRepository.getUser()).called(1);
    });

    test('닉네임이 없는 사용자도 올바르게 반환되어야 한다', () async {
      // Arrange
      final user = User(
        id: 789,
        loginId: 'lee',
        nickname: null, // 명시적으로 null 설정
      );
      when(mockRepository.getUser()).thenAnswer((_) async => user);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.id, equals(789));
      expect(result.loginId, equals('lee'));
      expect(result.nickname, isNull);
      verify(mockRepository.getUser()).called(1);
    });

    test('사용자 조회 시 네트워크 오류가 발생하면 예외를 처리해야 한다', () async {
      // Arrange
      when(mockRepository.getUser()).thenThrow(Exception('네트워크 연결 실패'));

      // Act & Assert
      expect(() => useCase.call(), throwsA(isA<Exception>()));
      verify(mockRepository.getUser()).called(1);
    });

    test('사용자 조회 시 인증 오류가 발생하면 예외를 처리해야 한다', () async {
      // Arrange
      when(mockRepository.getUser()).thenThrow(Exception('인증 토큰이 유효하지 않습니다'));

      // Act & Assert
      expect(() => useCase.call(), throwsA(isA<Exception>()));
      verify(mockRepository.getUser()).called(1);
    });
  });
}
