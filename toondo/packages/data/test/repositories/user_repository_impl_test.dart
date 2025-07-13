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
    group('닉네임 관련 테스트', () {
      test('updateNickName은 원격 및 로컬 데이터소스의 닉네임 업데이트 메서드를 호출해야 한다', () async {
        // Arrange
        const newNickname = '새로운닉네임';
        final updatedUser = TestData.createTestUser(nickname: newNickname);
        when(mockRemote.changeNickName(newNickname)).thenAnswer((_) async => updatedUser);
        when(mockLocal.setNickName(newNickname)).thenAnswer((_) async {});
        
        // Act
        final result = await repository.updateNickName(newNickname);
        
        // Assert
        expect(result.nickname, equals(newNickname));
        verify(mockRemote.changeNickName(newNickname));
        verify(mockLocal.setNickName(newNickname));
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

    group('포인트 관련 테스트', () {
      test('updateUserPoints는 원격 및 로컬 데이터소스의 포인트 업데이트 메서드를 호출해야 한다', () async {
        // Arrange
        const int newPoints = 50;
        final updatedUser = TestData.createTestUser(points: 150); // 기존 100 + 50 = 150
        when(mockRemote.updateUserPoints(newPoints)).thenAnswer((_) async => updatedUser);
        when(mockLocal.updateUserPoints(newPoints)).thenAnswer((_) async {});
        
        // Act
        final result = await repository.updateUserPoints(newPoints);
        
        // Assert
        expect(result.points, equals(150)); // 기존 100 + 50 = 150
        verify(mockRemote.updateUserPoints(newPoints));
        verify(mockLocal.updateUserPoints(newPoints));
      });
    });

    group('예외 처리 테스트', () {
      test('원격 데이터소스에서 예외 발생 시 그대로 전파되어야 한다', () async {
        // Arrange
        const newNickname = '예외발생닉네임';
        when(mockRemote.changeNickName(newNickname)).thenThrow(Exception('네트워크 오류'));
        
        // Act & Assert
        expect(() => repository.updateNickName(newNickname), throwsException);
        verify(mockRemote.changeNickName(newNickname));
        // 예외가 발생했으므로 로컬 업데이트는 호출되지 않아야 함
        verifyNever(mockLocal.setNickName(newNickname));
      });
    });
  });
}