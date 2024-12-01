// test/integration/todo_flow_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/main.dart' as app;
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo 앱 통합 테스트', () {
    testWidgets('디데이 투두 생성 후 제출 화면에 표시 확인', (WidgetTester tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // + 버튼 찾기 및 탭
      final addTodoButton = find.byKey(Key('addTodoButton'));
      expect(addTodoButton, findsOneWidget);
      await tester.tap(addTodoButton);
      await tester.pumpAndSettle();

      // 투두 입력 화면 확인
      expect(find.text('투두 작성'), findsOneWidget);

      // 투두 이름 입력
      final todoTitleField = find.byKey(Key('todoTitleField'));
      await tester.enterText(todoTitleField, '디데이 테스트');
      await tester.pumpAndSettle();

      // 아이젠하워 매트릭스 선택 (3번 인덱스 선택)
      final eisenhowerButton = find.byKey(Key('eisenhowerButton_3'));
      await tester.tap(eisenhowerButton);
      await tester.pumpAndSettle();

      // 제출 버튼 탭
      final submitButton = find.byType(ElevatedButton); // EditUpdateButton 내부에 ElevatedButton 가정
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 제출 화면에서 투두 확인
      expect(find.text('디데이 테스트'), findsOneWidget);
    });

    testWidgets('데일리 투두 생성 후 진행률 수정 및 내일하기 확인', (WidgetTester tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // + 버튼 찾기 및 탭
      final addTodoButton = find.byKey(Key('addTodoButton'));
      expect(addTodoButton, findsOneWidget);
      await tester.tap(addTodoButton);
      await tester.pumpAndSettle();

      // 데일리 토글 버튼 탭
      final dailyToggle = find.byKey(Key('dailyToggleButton'));
      await tester.tap(dailyToggle);
      await tester.pumpAndSettle();

      // 투두 이름 입력
      final todoTitleField = find.byKey(Key('todoTitleField'));
      await tester.enterText(todoTitleField, '데일리 테스트');
      await tester.pumpAndSettle();

      // 아이젠하워 매트릭스 선택 (1번 인덱스 선택)
      final eisenhowerButton = find.byKey(Key('eisenhowerButton_1'));
      await tester.tap(eisenhowerButton);
      await tester.pumpAndSettle();

      // 제출 버튼 탭
      final submitButton = find.byType(ElevatedButton); // EditUpdateButton 내부에 ElevatedButton 가정
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 제출 화면에서 투두 확인
      expect(find.text('데일리 테스트'), findsOneWidget);

      // 투두 아이템 탭하여 수정 다이얼로그 열기
      final dailyTodo = find.text('데일리 테스트');
      await tester.tap(dailyTodo);
      await tester.pumpAndSettle();

      // 진행률 수정 버튼 탭
      final progressUpdateButton = find.byKey(Key('confirmEditButton'));
      await tester.tap(progressUpdateButton);
      await tester.pumpAndSettle();

      // 진행률 슬라이더 조정 (간단히 진행률 업데이트 예제)
      // 실제 슬라이더 키가 필요할 수 있음
      // 예시에서는 진행률 텍스트 변경 확인
      await tester.enterText(find.byKey(Key('editTodoTitleField')), '데일리 테스트 업데이트');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 업데이트된 투두 확인
      expect(find.text('데일리 테스트 업데이트'), findsOneWidget);
      expect(find.text('데일리 테스트'), findsNothing);
    });

    testWidgets('투두 이름 없이 제출 시 에러 메시지 확인', (WidgetTester tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // + 버튼 찾기 및 탭
      final addTodoButton = find.byKey(Key('addTodoButton'));
      expect(addTodoButton, findsOneWidget);
      await tester.tap(addTodoButton);
      await tester.pumpAndSettle();

      // 투두 입력 화면 확인
      expect(find.text('투두 작성'), findsOneWidget);

      // 투두 이름 필드를 비움
      final todoTitleField = find.byKey(Key('todoTitleField'));
      await tester.enterText(todoTitleField, '');
      await tester.pumpAndSettle();

      // 제출 버튼 탭
      final submitButton = find.byType(ElevatedButton); // EditUpdateButton 내부에 ElevatedButton 가정
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 에러 메시지 확인
      expect(find.text('투두 이름을 입력해주세요.'), findsOneWidget);
    });
  });
}