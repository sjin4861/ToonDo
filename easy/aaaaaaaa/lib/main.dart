import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myapp',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              color: Colors.white,
              child: const Text('Container 1'),
            ),
            const SizedBox(
              width: 30.0,
            ),
            Container(
              height: 100,
              color: Colors.blue,
              child: const Text('Container 2'),
            ),
            Container(
              height: 100,
              color: Colors.red,
              child: const Text('Container 3'),
            ),
          ],
        ),
      ),
    );
  }
}

       

        // child: TextButton(
        //     onPressed: () {},
        //     style: TextButton.styleFrom(backgroundColor: Colors.white),
        //     child: const Text('Button'),
        //   ),