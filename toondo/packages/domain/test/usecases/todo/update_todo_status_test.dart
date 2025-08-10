import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import '../../mocks/mock_todo_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  late UpdateTodoStatusUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = UpdateTodoStatusUseCase(mockRepository);
  });

  group('UpdateTodoStatusUseCase', () {
    test('할일 상태가 성공적으로 업데이트되어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      const newStatus = 1.0; // 완료 상태
      when(mockRepository.updateTodoStatus(todo, newStatus))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo, newStatus);

      // Assert
      verify(mockRepository.updateTodoStatus(todo, newStatus)).called(1);
    });

    test('할일 상태를 0.0(미시작)으로 업데이트할 수 있어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      const newStatus = 0.0; // 미시작 상태
      when(mockRepository.updateTodoStatus(todo, newStatus))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo, newStatus);

      // Assert
      verify(mockRepository.updateTodoStatus(todo, newStatus)).called(1);
    });

    test('할일 상태를 0.5(진행중)로 업데이트할 수 있어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      const newStatus = 0.5; // 진행중 상태
      when(mockRepository.updateTodoStatus(todo, newStatus))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo, newStatus);

      // Assert
      verify(mockRepository.updateTodoStatus(todo, newStatus)).called(1);
    });

    test('할일 상태를 1.0(완료)로 업데이트할 수 있어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      const newStatus = 1.0; // 완료 상태
      when(mockRepository.updateTodoStatus(todo, newStatus))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo, newStatus);

      // Assert
      verify(mockRepository.updateTodoStatus(todo, newStatus)).called(1);
    });

    test('Repository에서 예외가 발생하면 예외가 전파되어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      const newStatus = 1.0;
      when(mockRepository.updateTodoStatus(todo, newStatus))
          .thenThrow(Exception('업데이트 실패'));

      // Act & Assert
      expect(() => useCase.call(todo, newStatus), throwsException);
      verify(mockRepository.updateTodoStatus(todo, newStatus)).called(1);
    });

    test('여러 할일의 상태를 순차적으로 업데이트할 수 있어야 한다', () async {
      // Arrange
      final todo1 = TestData.createTestTodo(id: 'todo-1');
      final todo2 = TestData.createTestTodo(id: 'todo-2');
      final todo3 = TestData.createTestTodo(id: 'todo-3');
      
      when(mockRepository.updateTodoStatus(todo1, 0.5))
          .thenAnswer((_) async => {});
      when(mockRepository.updateTodoStatus(todo2, 1.0))
          .thenAnswer((_) async => {});
      when(mockRepository.updateTodoStatus(todo3, 0.0))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo1, 0.5);
      await useCase.call(todo2, 1.0);
      await useCase.call(todo3, 0.0);

      // Assert
      verify(mockRepository.updateTodoStatus(todo1, 0.5)).called(1);
      verify(mockRepository.updateTodoStatus(todo2, 1.0)).called(1);
      verify(mockRepository.updateTodoStatus(todo3, 0.0)).called(1);
    });

    test('동일한 할일의 상태를 여러 번 업데이트할 수 있어야 한다', () async {
      // Arrange
      final todo = TestData.createTestTodo(id: 'test-todo-1');
      when(mockRepository.updateTodoStatus(todo, 0.0))
          .thenAnswer((_) async => {});
      when(mockRepository.updateTodoStatus(todo, 0.5))
          .thenAnswer((_) async => {});
      when(mockRepository.updateTodoStatus(todo, 1.0))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo, 0.0); // 미시작
      await useCase.call(todo, 0.5); // 진행중
      await useCase.call(todo, 1.0); // 완료

      // Assert
      verify(mockRepository.updateTodoStatus(todo, 0.0)).called(1);
      verify(mockRepository.updateTodoStatus(todo, 0.5)).called(1);
      verify(mockRepository.updateTodoStatus(todo, 1.0)).called(1);
    });

    test('상태 업데이트 중 일부 할일에서 예외가 발생해도 다른 할일은 정상 업데이트되어야 한다', () async {
      // Arrange
      final todo1 = TestData.createTestTodo(id: 'todo-1');
      final todo2 = TestData.createTestTodo(id: 'todo-2'); // 이것은 실패
      final todo3 = TestData.createTestTodo(id: 'todo-3');
      
      when(mockRepository.updateTodoStatus(todo1, 1.0))
          .thenAnswer((_) async => {});
      when(mockRepository.updateTodoStatus(todo2, 1.0))
          .thenThrow(Exception('업데이트 실패'));
      when(mockRepository.updateTodoStatus(todo3, 1.0))
          .thenAnswer((_) async => {});

      // Act
      await useCase.call(todo1, 1.0); // 성공
      
      // todo2 업데이트 시 예외 발생
      expect(() => useCase.call(todo2, 1.0), throwsException);
      
      await useCase.call(todo3, 1.0); // 성공

      // Assert
      verify(mockRepository.updateTodoStatus(todo1, 1.0)).called(1);
      verify(mockRepository.updateTodoStatus(todo2, 1.0)).called(1);
      verify(mockRepository.updateTodoStatus(todo3, 1.0)).called(1);
    });
  });
}
