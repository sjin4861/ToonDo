import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:domain/entities/todo.dart';
import '../../mocks/mock_todo_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late FetchTodosUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = FetchTodosUseCase(mockRepository);
  });

  group('FetchTodosUseCase', () {
    test('할일 목록이 성공적으로 반환되어야 한다', () async {
      // Arrange
      final todos = [
        TestData.createTestTodo(id: 'todo-1', title: '할일 1'),
        TestData.createTestTodo(id: 'todo-2', title: '할일 2'),
        TestData.createTestTodo(id: 'todo-3', title: '할일 3'),
      ];
      when(mockRepository.fetchTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(todos));
      expect(result.length, equals(3));
      verify(mockRepository.fetchTodos()).called(1);
    });

    test('빈 할일 목록이 반환되어야 한다', () async {
      // Arrange
      when(mockRepository.fetchTodos()).thenAnswer((_) async => <Todo>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.fetchTodos()).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      when(mockRepository.fetchTodos()).thenThrow(Exception('네트워크 오류'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(mockRepository.fetchTodos()).called(1);
    });

    test('매번 호출할 때마다 Repository를 호출해야 한다', () async {
      // Arrange
      final todos = [TestData.createTestTodo(id: 'todo-1')];
      when(mockRepository.fetchTodos()).thenAnswer((_) async => todos);

      // Act
      await useCase.call();
      await useCase.call();
      await useCase.call();

      // Assert
      verify(mockRepository.fetchTodos()).called(3);
    });

    test('다양한 상태의 할일들이 모두 포함되어야 한다', () async {
      // Arrange - Todo는 double status 값을 사용
      final todos = [
        TestData.createTestTodo(id: 'todo-1', status: 0.0),   // 시작 안함
        TestData.createTestTodo(id: 'todo-2', status: 0.5),   // 진행중
        TestData.createTestTodo(id: 'todo-3', status: 1.0),   // 완료
        TestData.createTestTodo(id: 'todo-4', status: 0.8),   // 거의 완료
      ];
      when(mockRepository.fetchTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.length, equals(4));
      expect(result.map((todo) => todo.status).toSet(), 
             equals({0.0, 0.5, 1.0, 0.8}));
      verify(mockRepository.fetchTodos()).called(1);
    });

    test('반환된 할일 목록의 순서가 Repository에서 반환한 순서와 동일해야 한다', () async {
      // Arrange
      final todos = [
        TestData.createTestTodo(id: 'todo-3', title: 'C'),
        TestData.createTestTodo(id: 'todo-1', title: 'A'),
        TestData.createTestTodo(id: 'todo-2', title: 'B'),
      ];
      when(mockRepository.fetchTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result[0].title, equals('C'));
      expect(result[1].title, equals('A'));
      expect(result[2].title, equals('B'));
      verify(mockRepository.fetchTodos()).called(1);
    });
  });
}
