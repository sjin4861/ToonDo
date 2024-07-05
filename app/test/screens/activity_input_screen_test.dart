import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/activity_input_screen.dart';

void main() {
  testWidgets('ActivityInputScreen has an activity input field', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ActivityInputScreen()));

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Log Activity'), findsOneWidget);
  });

  testWidgets('ActivityInputScreen form validation', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ActivityInputScreen()));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter an activity'), findsOneWidget);
  });
}