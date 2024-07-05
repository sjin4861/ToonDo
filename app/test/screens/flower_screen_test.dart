import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blossomdays/screens/flower_screen.dart';

void main() {
  testWidgets('FlowerScreen displays flower information', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: FlowerScreen()));

    expect(find.text('Your Flower'), findsOneWidget);
    expect(find.text('Watered: 3 times'), findsOneWidget);
    expect(find.text('Growth: 70%'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}