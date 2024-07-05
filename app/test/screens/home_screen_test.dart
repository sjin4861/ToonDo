import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/home_screen.dart';
import 'package:blossomdays/screens/login_screen.dart';
import 'package:blossomdays/screens/flower_screen.dart';
import 'package:blossomdays/screens/activity_input_screen.dart';
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

  testWidgets('HomeScreen navigates to FlowerScreen after login', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/home',
      routes: Routes.routes,
    ));

    // Navigate to LoginScreen
    await tester.tap(find.byKey(Key('main_button')));
    await tester.pumpAndSettle();

    // Perform login
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password');
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    // Verify we are back on HomeScreen with "Go to Flower" and "Log Activity" buttons
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Go to Flower'), findsOneWidget);
    expect(find.text('Log Activity'), findsOneWidget);

    // Navigate to FlowerScreen
    await tester.tap(find.text('Go to Flower'));
    await tester.pumpAndSettle();

    expect(find.byType(FlowerScreen), findsOneWidget);
  });

  testWidgets('HomeScreen navigates to ActivityInputScreen after login', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/home',
      routes: Routes.routes,
    ));

    // Navigate to LoginScreen
    await tester.tap(find.byKey(Key('main_button')));
    await tester.pumpAndSettle();

    // Perform login
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password');
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    // Verify we are back on HomeScreen with "Go to Flower" and "Log Activity" buttons
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Go to Flower'), findsOneWidget);
    expect(find.text('Log Activity'), findsOneWidget);

    await tester.tap(find.text('Log Activity'));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityInputScreen), findsOneWidget);
  });
}