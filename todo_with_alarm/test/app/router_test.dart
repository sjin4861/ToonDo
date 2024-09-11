import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/app/app.dart';
import 'package:todo_with_alarm/screens/home_screen.dart';
import 'package:todo_with_alarm/screens/settings_screen.dart';
import 'package:todo_with_alarm/screens/progress_screen.dart';

void main() {
  testWidgets('App navigates correctly using routes', (WidgetTester tester) async {
    // MyApp 위젯을 빌드합니다.
    await tester.pumpWidget(MyApp(isGoalSet: true));

    // 처음 화면은 HomeScreen 이어야 합니다.
    expect(find.byType(HomeScreen), findsOneWidget);

    // 라우팅 테스트: '/settings'로 이동
    await tester.tap(find.text('Go to Settings')); // 'Go to Settings' 버튼을 탭합니다.
    await tester.pumpAndSettle(); // 애니메이션이 완료될 때까지 대기합니다.

    // 설정 화면으로 이동했는지 확인합니다.
    expect(find.byType(SettingsScreen), findsOneWidget);

    // 라우팅 테스트: '/progress'로 이동
    await tester.tap(find.text('Go to Progress')); // 'Go to Progress' 버튼을 탭합니다.
    await tester.pumpAndSettle();

    // 진행률 화면으로 이동했는지 확인합니다.
    expect(find.byType(ProgressScreen), findsOneWidget);
  });
}