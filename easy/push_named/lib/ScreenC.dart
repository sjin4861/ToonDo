import 'package:flutter/material.dart';

class ScreenC extends StatelessWidget {
  const ScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen C'),
      ),
      body: const Center(
        child: Text(
          'Screen C',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
