import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Buttons',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                print('text button');
              },
              onLongPress: () {
                print('text buttonnnn');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Text button',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Elevated button');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.0),
              child: const Text('Elevated Button'),
            ),
            OutlinedButton(
              onPressed: () {
                print('Outlined button');
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green,
                side: const BorderSide(
                  color: Colors.black87,
                  width: 2.0,
                ),
              ),
              child: const Text('Outlined button'),
            ),
            TextButton.icon(
              onPressed: () {
                print('Icon button');
              },
              icon: const Icon(Icons.home, size: 30.0, color: Colors.black),
              label: const Text('GO to home'),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: const Size(50, 100),
                  surfaceTintColor: Colors.black),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: const EdgeInsets.all(20),
              children: [
                TextButton(onPressed: () {}, child: const Text('Textbutton')),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Elevated button'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
