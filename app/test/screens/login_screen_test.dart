import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen has a login button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    final loginButton = find.byType(ElevatedButton);

    expect(loginButton, findsOneWidget);

    final buttonText = tester.widget<ElevatedButton>(loginButton).child as Text;
    expect(buttonText.data, 'Login');
  });

  testWidgets('LoginScreen form validation', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}