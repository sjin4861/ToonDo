import 'package:data/datasources/local/user_local_datasource.dart';
import 'package:data/datasources/remote/user_remote_datasource.dart';
import 'package:data/repositories/user_repository_impl.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([
  UserLocalDatasource,
  UserRemoteDatasource,
])
void main() {
  late UserRepository repository;
  late MockUserLocalDatasource mockLocal;
  late MockUserRemoteDatasource mockRemote;

  setUp(() {
    mockLocal = MockUserLocalDatasource();
    mockRemote = MockUserRemoteDatasource();
    repository = UserRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
    );
  });

  group('UserRepositoryImpl', () {
    group('사용자 정보 조회 테스트', () {
      test('getUser는 로컬 데이터소스의 getUser를 호출하고 User를 반환해야 한다', () async {
        // Arrange
        final testUser = TestData.createTestUser(loginId: 'testuser');
        when(mockLocal.getUser()).thenAnswer((_) async => testUser);

        // Act
        final result = await repository.getUser();

        // Assert
        expect(result.loginId, equals('testuser'));
        verify(mockLocal.getUser()).called(1);
      });
    });

    group('닉네임 관련 테스트', () {
      test('updateNickName은 원격 및 로컬 데이터소스의 닉네임 업데이트 메서드를 호출해야 한다', () async {
        // Arrange
        const newNickname = '새로운닉네임';
        when(mockRemote.changeNickName(newNickname)).thenAnswer((_) async => newNickname);
        when(mockLocal.getUser()).thenAnswer((_) async => TestData.createTestUser());
        when(mockLocal.saveUser(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.updateNickName(newNickname);

        // Assert
        expect(result.nickname, equals(newNickname));
        verify(mockRemote.changeNickName(newNickname)).called(1);
        verify(mockLocal.saveUser(any)).called(1);
      });

      test('getUserNickname은 로컬 데이터소스의 닉네임 조회 메서드를 호출해야 한다', () async {
        // Arrange
        const expectedNickname = '테스트닉네임';
        when(mockLocal.getUserNickname()).thenAnswer((_) async => expectedNickname);
        
        // Act
        final result = await repository.getUserNickname();

        // Assert
        expect(result, equals(expectedNickname));
        verify(mockLocal.getUserNickname());
      });
    });

    group('계정 삭제 테스트', () {
      test('deleteAccount는 원격 및 로컬 데이터소스의 계정 삭제 메서드를 호출해야 한다', () async {
        // Arrange
        when(mockRemote.deleteAccount()).thenAnswer((_) async {});
        when(mockLocal.clearUser()).thenAnswer((_) async {});

        // Act
        await repository.deleteAccount();

        // Assert
        verify(mockRemote.deleteAccount()).called(1);
        verify(mockLocal.clearUser()).called(1);
      });
    });
  });
}