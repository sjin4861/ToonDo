import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen displays user information', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen()));

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('email@example.com'), findsOneWidget);
    expect(find.text('About Me'), findsOneWidget);
  });
}