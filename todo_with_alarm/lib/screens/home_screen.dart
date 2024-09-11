import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Go to Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/progress');
              },
              child: Text('Go to Progress'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/todo'); // TodoSubmissionScreen으로 이동
              },
              child: Text('Go to Todo Submission'),
            ),
          ],
        ),
      ),
    );
  }
}