import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/screens/home_screen.dart';
import 'package:todo_with_alarm/screens/settings_screen.dart';
import 'package:todo_with_alarm/screens/progress_screen.dart';

void main() {
  testWidgets('HomeScreen shows buttons and navigates correctly', (WidgetTester tester) async {
    // HomeScreen 위젯을 빌드합니다.
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
      routes: {
        '/settings': (context) => SettingsScreen(), // 라우팅을 설정
        '/progress': (context) => ProgressScreen(), // 라우팅을 설정
      },
    ));

    // "Go to Settings" 버튼이 있는지 확인합니다.
    expect(find.text('Go to Settings'), findsOneWidget);

    // "Go to Progress" 버튼이 있는지 확인합니다.
    expect(find.text('Go to Progress'), findsOneWidget);

    // "Go to Settings" 버튼을 탭합니다.
    await tester.tap(find.text('Go to Settings'));
    await tester.pumpAndSettle();

    // 설정 화면으로 이동했는지 확인합니다.
    expect(find.byType(SettingsScreen), findsOneWidget);

    // "Go to Progress" 버튼을 탭합니다.
    await tester.tap(find.text('Go to Progress'));
    await tester.pumpAndSettle();

    // 진행률 화면으로 이동했는지 확인합니다.
    expect(find.byType(ProgressScreen), findsOneWidget);
  });
}