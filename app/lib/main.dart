import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'services/user_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserService(),
      child: BlossomDaysApp(),
    ),
  );
}

class BlossomDaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlossomDays',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/onboarding',
      routes: Routes.routes,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}