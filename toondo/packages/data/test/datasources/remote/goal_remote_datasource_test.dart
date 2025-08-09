import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:data/constants.dart';

import 'goal_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client, AuthRepository])
void main() {
  late GoalRemoteDataSource dataSource;
  late MockClient mockClient;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockClient = MockClient();
    mockAuthRepository = MockAuthRepository();
    dataSource = GoalRemoteDataSource(mockClient, mockAuthRepository);
  });

  group('GoalRemoteDataSource', () {
    const testToken = 'test_jwt_token';
    
    setUp(() {
      when(mockAuthRepository.getToken())
          .thenAnswer((_) async => testToken);
    });

    group('readGoals', () {
      const mockResponseBody = '''[{"id": "1","goalName": "테스트 목표","startDate": "2024-01-01","endDate": "2024-12-31","icon": "test_icon","status": 0,"progress": 50.0}]''';

      test('전체 목표 조회 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/list');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(mockResponseBody, 200, headers: {'content-type': 'application/json; charset=utf-8'}));

        // Act
        final result = await dataSource.readGoals();

        // Assert
        expect(result, isA<List<Goal>>());
        expect(result.length, 1);
        expect(result.first.name, '테스트 목표');
        verify(mockClient.get(url, headers: anyNamed('headers'))).called(1);
      });

      test('401 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/list');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Unauthorized', 401));

        // Act & Assert
        expect(
          () => dataSource.readGoals(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('인증 오류 (401 Unauthorized)'),
          )),
        );
      });

      test('JWT 토큰이 없을 때 예외 발생', () async {
        // Arrange
        when(mockAuthRepository.getToken()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () => dataSource.readGoals(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('JWT 토큰이 없습니다'),
          )),
        );
      });
    });

    group('createGoal', () {
      final testGoal = Goal(
        id: '',
        name: '새 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 0.0,
      );

      const mockResponseBody = '''{"id": "1","goalName": "새 목표","startDate": "2024-01-01","endDate": "2024-12-31","icon": "test_icon","status": 0,"progress": 0.0}''';

      test('목표 생성 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/create');
        when(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponseBody, 201, headers: {'content-type': 'application/json; charset=utf-8'}));

        // Act
        final result = await dataSource.createGoal(testGoal);

        // Assert
        expect(result, isA<Goal>());
        expect(result.name, '새 목표');
        verify(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/create');
        when(mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Bad Request', 400));

        // Act & Assert
        expect(
          () => dataSource.createGoal(testGoal),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('잘못된 요청 (400 Bad Request)'),
          )),
        );
      });
    });

    group('updateGoal', () {
      final testGoal = Goal(
        id: '1',
        name: '업데이트된 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'updated_icon',
        status: Status.inProgress,
        progress: 75.0,
      );

      test('목표 업데이트 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/update/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 200));

        // Act
        await dataSource.updateGoal(testGoal);

        // Assert
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('400 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/update/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Bad Request', 400));

        // Act & Assert
        expect(
          () => dataSource.updateGoal(testGoal),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('잘못된 요청 (400 Bad Request)'),
          )),
        );
      });
    });

    group('updateGoalStatus', () {
      final testGoal = Goal(
        id: '1',
        name: '테스트 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 50.0,
      );

      const mockResponseBody = '''{"message": "목표 상태가 업데이트되었습니다","progress": 100}''';

      test('목표 상태 업데이트 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/update/status/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponseBody, 200, headers: {'content-type': 'application/json; charset=utf-8'}));

        // Act
        final result = await dataSource.updateGoalStatus(testGoal, Status.completed);

        // Assert
        expect(result, true);
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('500 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/update/status/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        // Act & Assert
        expect(
          () => dataSource.updateGoalStatus(testGoal, Status.completed),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('서버 내부 오류 (500 Internal Server Error)'),
          )),
        );
      });
    });

    group('updateGoalProgress', () {
      final testGoal = Goal(
        id: '1',
        name: '테스트 목표',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        icon: 'test_icon',
        status: Status.inProgress,
        progress: 50.0,
      );

      const mockResponseBody = '''{"message": "목표 진행률이 업데이트되었습니다","progress": 75}''';

      test('목표 진행률 업데이트 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/update/progress/1');
        when(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(mockResponseBody, 200, headers: {'content-type': 'application/json; charset=utf-8'}));

        // Act
        final result = await dataSource.updateGoalProgress(testGoal, 75.0);

        // Assert
        expect(result, true);
        verify(mockClient.put(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('잘못된 progress 값으로 예외 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.updateGoalProgress(testGoal, 150.0),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('progress 값은 0~100 사이여야 합니다'),
          )),
        );
      });

      test('음수 progress 값으로 예외 발생', () async {
        // Act & Assert
        expect(
          () => dataSource.updateGoalProgress(testGoal, -10.0),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('progress 값은 0~100 사이여야 합니다'),
          )),
        );
      });
    });

    group('deleteGoal', () {
      test('목표 삭제 성공', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/delete/1');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('', 200));

        // Act
        await dataSource.deleteGoal('1');

        // Assert
        verify(mockClient.delete(url, headers: anyNamed('headers'))).called(1);
      });

      test('403 에러 처리', () async {
        // Arrange
        final url = Uri.parse('${Constants.baseUrl}/goals/delete/1');
        when(mockClient.delete(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Forbidden', 403));

        // Act & Assert
        expect(
          () => dataSource.deleteGoal('1'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('권한 오류 (403 Forbidden)'),
          )),
        );
      });
    });

    group('Bearer token 처리', () {
      test('Bearer 프리픽스가 없는 토큰에 자동으로 추가', () async {
        // Arrange
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'raw_token_without_bearer');
        
        final url = Uri.parse('${Constants.baseUrl}/goals/list');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('[]', 200));

        // Act
        await dataSource.readGoals();

        // Assert
        verify(mockClient.get(
          url,
          headers: argThat(
            contains('Authorization'),
            named: 'headers',
          ),
        )).called(1);
      });

      test('이미 Bearer 프리픽스가 있는 토큰은 그대로 사용', () async {
        // Arrange
        when(mockAuthRepository.getToken())
            .thenAnswer((_) async => 'Bearer existing_token');
        
        final url = Uri.parse('${Constants.baseUrl}/goals/list');
        when(mockClient.get(url, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('[]', 200));

        // Act
        await dataSource.readGoals();

        // Assert
        verify(mockClient.get(
          url,
          headers: argThat(
            contains('Authorization'),
            named: 'headers',
          ),
        )).called(1);
      });
    });
  });
}
