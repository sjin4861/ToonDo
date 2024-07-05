import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(BlossomDaysApp());
}

class BlossomDaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlossomDays',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/home',
      routes: Routes.routes,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}