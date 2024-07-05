import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  void _login() async {
    final result = await Navigator.pushNamed(context, '/login');
    if (result == true) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // 업로드한 배경 이미지 경로로 변경
              fit: BoxFit.cover,
            ),
          ),
          // 콘텐츠 추가
          Column(
            children: [
              const SizedBox(height: 80), // 상단 여백 추가
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.black.withOpacity(0.5), // 배경색 추가, 투명도 조절 가능
                child: const Text(
                  'Welcome to BlossomDays!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80), // 추가 여백을 통해 버튼을 아래로 이동
                    ElevatedButton(
                      key: Key('main_button'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        if (isLoggedIn) {
                          Navigator.pushNamed(context, '/flower');
                        } else {
                          _login();
                        }
                      },
                      child: Text(
                        isLoggedIn ? 'Go to Flower' : 'Go to Login',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}