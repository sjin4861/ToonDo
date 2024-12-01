import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:todo_with_alarm/views/todo/todo_input_screen.dart';
import '../../mocks/mock_todo_service.mocks.dart';
import '../../mocks/mock_goal_service.mocks.dart'; // MockGoalService 임포트 추가
import 'package:todo_with_alarm/widgets/bottom_button/edit_update_button.dart'; // EditUpdateButton 임포트 추가
import 'package:mockito/annotations.dart';

@GenerateMocks([TodoService, GoalService])
void main() {
  group('TodoInputScreen 위젯 테스트', () {
    late MockTodoService mockTodoService;
    late MockGoalService mockGoalService;
    late GoalViewModel goalViewModel;

    setUp(() {
      mockTodoService = MockTodoService();
      mockGoalService = MockGoalService();

      // Mock GoalService의 메서드 스텁 설정
      when(mockGoalService.loadGoals()).thenAnswer((_) async => [
            Goal(id: 'goal1', name: '목표 1', startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 30))),
            Goal(id: 'goal2', name: '목표 2', startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 30))),
          ]);
      when(mockGoalService.createGoal(any)).thenAnswer((_) async => Future.value());

      goalViewModel = GoalViewModel(goalService: mockGoalService);
      // Mock 목표 데이터 설정
      goalViewModel.loadGoals();
    });

    Widget createWidgetUnderTest({Todo? todo, bool isDDayTodo = true}) {
      return MultiProvider(
        providers: [
          Provider<TodoService>.value(value: mockTodoService),
          ChangeNotifierProvider<GoalViewModel>.value(value: goalViewModel),
        ],
        child: MaterialApp(
          home: TodoInputScreen(
            todo: todo,
            isDDayTodo: isDDayTodo,
          ),
        ),
      );
    }

    testWidgets('투두 제출 버튼 탭 시 저장 메서드 호출 확인', (WidgetTester tester) async {
      // Mock TodoService의 addTodo 메서드 스텁 설정
      when(mockTodoService.addTodo(any)).thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());

      // 위젯 트리 출력
      debugDumpRenderTree();

      // 투두 이름 입력
      await tester.enterText(find.byKey(Key('todoTitleField')), '테스트 투두');
      await tester.pump();

      // 제출 버튼 탭
      await tester.tap(find.byKey(Key('editUpdateButton')));
      await tester.pumpAndSettle(); // 비동기 처리 완료 대기

      // saveTodo 메서드가 호출되었는지 확인
      verify(mockTodoService.addTodo(any)).called(1);
    });
  });
}
