import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../packages/data/lib/repositories/todo_repository.dart';
import 'package:toondo/data/models/todo.dart';
import 'package:hive/hive.dart';
import '../../mocks/mock_todo_datasources.dart'; // TodoAdapter가 포함된 파일도 확인

void main() {
  setUpAll(() async {
    Hive.init('./test/hive_test'); // 테스트 전용 디렉토리 설정
    Hive.registerAdapter(TodoAdapter()); // 실제 Adapter 사용 중이라면 등록
    await Hive.openBox<Todo>('todos');
    await Hive.openBox<Todo>('deleted_todos');
  });

  tearDownAll(() async {
    await Hive.box<Todo>('todos').clear();
    await Hive.box<Todo>('deleted_todos').clear();
    await Hive.close();
  });

  group('TodoRepository Unit Test', () {
    late TodoRepository repository;
    late MockTodoLocalDatasource mockLocal;
    late MockTodoRemoteDatasource mockRemote;

    setUp(() {
      mockLocal = MockTodoLocalDatasource();
      mockRemote = MockTodoRemoteDatasource();
      repository = TodoRepository(
        localDatasource: mockLocal,
        remoteDatasource: mockRemote,
      );
    });

    test('commitTodos should mark unsynced todos as synced and clear deleted todos', () async {
      // Arrange: unsynced todos와 deleted todos 생성
      final todo1 = Todo(id: '1', title: 'Todo 1', goalId : "1", startDate: DateTime.now(), endDate: DateTime.now(), isSynced: false);
      final todo2 = Todo(id: '2', title: 'Todo 2', goalId : "2", startDate: DateTime.now(), endDate: DateTime.now(), isSynced: false);
      final unsyncedTodos = [todo1, todo2];
      final deletedTodos = [todo1];

      when(mockLocal.saveTodo(todo1)).thenAnswer((_) async => true);
      when(mockLocal.saveTodo(todo2)).thenAnswer((_) async => true);
      when(mockLocal.getUnsyncedTodos()).thenReturn(unsyncedTodos);
      when(mockLocal.deleteTodo(todo1)).thenAnswer((_) async {});
      when(mockLocal.getDeletedTodos()).thenReturn(deletedTodos);
      // commitTodos() 호출 시 임의의 토큰이 있다고 가정하여 true 반환
      when(mockRemote.commitTodos(unsyncedTodos, deletedTodos)).thenAnswer((_) async => true);
      // 반환값으로 Future<void>를 반환하도록 수정
      when(mockLocal.syncTodos(unsyncedTodos)).thenAnswer((_) async {});
      when(mockLocal.clearDeletedTodos()).thenAnswer((_) async {});

      // Act
      final result = await repository.commitTodos();

      // Assert
      expect(result, true);
      verify(mockLocal.syncTodos(unsyncedTodos)).called(1);
      verify(mockLocal.clearDeletedTodos()).called(1);
    });

    test('fetchTodos should fetch and return updated todos', () async {
      // Arrange
      final fetchedTodos = [
        Todo(id: '3', title: 'Fetched 1', goalId: '3', startDate: DateTime.now(), endDate: DateTime.now(), isSynced: true),
        Todo(id: '4', title: 'Fetched 2', goalId: '4', startDate: DateTime.now(), endDate: DateTime.now(), isSynced: true),
      ];
      when(mockRemote.fetchTodos()).thenAnswer((_) async => fetchedTodos);
      // Act
      final result = await repository.fetchTodos();
      // Assert
      expect(result.length, 2);
      verify(mockRemote.fetchTodos()).called(1);
    });

    test('updateTodo should update local data and mark the todo as unsynced', () async {
      // Arrange
      final todoToUpdate = Todo(id: '5', title: 'Old Title', startDate: DateTime.now(), endDate: DateTime.now(), isSynced: true);
      when(mockLocal.saveTodo(todoToUpdate)).thenAnswer((_) async => true);
      // Act
      await repository.updateTodo(todoToUpdate..title = 'New Title');
      // Assert
      expect(todoToUpdate.title, 'New Title');
    });

    test('createTodo should call localDatasource.saveTodo and return true', () async {
      // Arrange
      final newTodo = Todo(id: '10', title: 'New Todo', startDate: DateTime.now(), endDate: DateTime.now());
      when(mockLocal.saveTodo(newTodo)).thenAnswer((_) async => true);
      // Act
      final result = await repository.createTodo(newTodo);
      // Assert
      expect(result, true);
      verify(mockLocal.saveTodo(newTodo)).called(1);
    });

    test('deleteTodo should remove a todo from local storage and move it to deletedTodos', () async {
      // Arrange
      final todoToDelete = Todo(id: '11', title: 'Delete Me', startDate: DateTime.now(), endDate: DateTime.now());
      when(mockLocal.deleteTodo(todoToDelete)).thenAnswer((_) async {});
      // Act
      await repository.deleteTodo(todoToDelete);
      // Assert
      verify(mockLocal.deleteTodo(todoToDelete)).called(1);
    });

    test('getLocalTodos should return all todos from localDatasource', () {
      // Arrange
      final localTodos = [
        Todo(id: '12', title: 'Local 1', startDate: DateTime.now(), endDate: DateTime.now()),
        Todo(id: '13', title: 'Local 2', startDate: DateTime.now(), endDate: DateTime.now()),
      ];
      when(mockLocal.getAllTodos()).thenReturn(localTodos);
      // Act
      final result = repository.getLocalTodos();
      // Assert
      expect(result.length, 2);
      expect(result[0].id, '12');
      verify(mockLocal.getAllTodos()).called(1);
    });
  });
}
