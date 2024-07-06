import 'package:flutter/material.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B'),
      ),
      body: const Center(
        child: Text(
          'Screen B',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
