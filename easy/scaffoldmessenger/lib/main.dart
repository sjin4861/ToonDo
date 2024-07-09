import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        title: const Text('Scaffold Messenger'),
      ),
      body: const Homebody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.thumb_up),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Like a new Snack Bar!'),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ThirdPage()),
                    );
                  },
                )),
          );
        },
      ),
    );
  }
}

class Homebody extends StatelessWidget {
  const Homebody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          child: const Text('Go to the second page'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SecondPage()));
          }),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: const Center(
        child: Text(
          '좋아요가 추가 되었습니다.',
          style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Third Page'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '좋아요를 취소하시겠습니까?',
                  style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('"좋아요"가 취소되었습니다.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text('취소하기'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
