import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/home_screen.dart';
import 'package:blossomdays/screens/login_screen.dart';
import 'package:blossomdays/routes.dart';

void main() {
  testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    expect(find.text('Welcome to BlossomDays!'), findsOneWidget);
  });

  testWidgets('HomeScreen has a button to navigate to LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/home',
      routes: Routes.routes,
    ));

    expect(find.text('Go to Login'), findsOneWidget);

    await tester.tap(find.text('Go to Login'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}