import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import '../../mocks/mock_todo_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late DeleteTodoUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = DeleteTodoUseCase(mockRepository);
  });

  group('DeleteTodoUseCase', () {
    test('할일 삭제가 성공적으로 호출되어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.deleteTodo(todo)).thenAnswer((_) async => {});

      // Act
      await useCase.call(todo);

      // Assert
      verify(mockRepository.deleteTodo(todo)).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.deleteTodo(todo)).thenThrow(Exception('삭제 실패'));

      // Act & Assert
      expect(() => useCase.call(todo), throwsException);
      verify(mockRepository.deleteTodo(todo)).called(1);
    });

    test('여러 개의 할일을 순차적으로 삭제할 수 있어야 한다', () async {
      // Arrange
      final todo1 = TestData.createTestTodo(id: 'test-todo-1');
      final todo2 = TestData.createTestTodo(id: 'test-todo-2');
      final todo3 = TestData.createTestTodo(id: 'test-todo-3');
      
      when(mockRepository.deleteTodo(todo1)).thenAnswer((_) async => {});
      when(mockRepository.deleteTodo(todo2)).thenAnswer((_) async => {});
      when(mockRepository.deleteTodo(todo3)).thenAnswer((_) async => {});

      // Act
      await useCase.call(todo1);
      await useCase.call(todo2);
      await useCase.call(todo3);

      // Assert
      verify(mockRepository.deleteTodo(todo1)).called(1);
      verify(mockRepository.deleteTodo(todo2)).called(1);
      verify(mockRepository.deleteTodo(todo3)).called(1);
    });

    test('동일한 할일을 여러 번 삭제하려고 해도 각각 Repository를 호출해야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.deleteTodo(todo)).thenAnswer((_) async => {});

      // Act
      await useCase.call(todo);
      await useCase.call(todo);

      // Assert
      verify(mockRepository.deleteTodo(todo)).called(2);
    });

    test('삭제 중 일부 할일에서 예외가 발생해도 다른 할일은 정상 삭제되어야 한다', () async {
      // Arrange
      final todo1 = TestData.createTestTodo(id: 'test-todo-1');
      final todo2 = TestData.createTestTodo(id: 'test-todo-2'); // 이것은 실패
      final todo3 = TestData.createTestTodo(id: 'test-todo-3');
      
      when(mockRepository.deleteTodo(todo1)).thenAnswer((_) async => {});
      when(mockRepository.deleteTodo(todo2)).thenThrow(Exception('삭제 실패'));
      when(mockRepository.deleteTodo(todo3)).thenAnswer((_) async => {});

      // Act
      await useCase.call(todo1); // 성공
      
      // todo2 삭제 시 예외 발생
      expect(() => useCase.call(todo2), throwsException);
      
      await useCase.call(todo3); // 성공

      // Assert
      verify(mockRepository.deleteTodo(todo1)).called(1);
      verify(mockRepository.deleteTodo(todo2)).called(1);
      verify(mockRepository.deleteTodo(todo3)).called(1);
    });
  });
}
