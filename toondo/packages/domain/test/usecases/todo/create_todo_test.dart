import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import '../../mocks/mock_todo_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late CreateTodoUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = CreateTodoUseCase(mockRepository);
  });

  group('CreateTodoUseCase', () {
    test('할일 생성이 성공하면 true를 반환해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.createTodo(todo)).thenAnswer((_) async => true);

      // Act
      final result = await useCase.call(todo);

      // Assert
      expect(result, isTrue);
      verify(mockRepository.createTodo(todo)).called(1);
    });

    test('할일 생성이 실패하면 false를 반환해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.createTodo(todo)).thenAnswer((_) async => false);

      // Act
      final result = await useCase.call(todo);

      // Assert
      expect(result, isFalse);
      verify(mockRepository.createTodo(todo)).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.createTodo(todo)).thenThrow(Exception('생성 실패'));

      // Act & Assert
      expect(() => useCase.call(todo), throwsException);
      verify(mockRepository.createTodo(todo)).called(1);
    });

    test('여러 번 호출되어도 각각 Repository를 호출해야 한다', () async {
      // Arrange
      final todo1 = TestData.createTestTodo(id: 'test-todo-1');
      final todo2 = TestData.createTestTodo(id: 'test-todo-2');
      when(mockRepository.createTodo(todo1)).thenAnswer((_) async => true);
      when(mockRepository.createTodo(todo2)).thenAnswer((_) async => true);

      // Act
      await useCase.call(todo1);
      await useCase.call(todo2);

      // Assert
      verify(mockRepository.createTodo(todo1)).called(1);
      verify(mockRepository.createTodo(todo2)).called(1);
    });
  });
}
