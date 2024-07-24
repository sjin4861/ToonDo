import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _login() async {
    final result = await Navigator.pushNamed(context, '/login');
    if (result == true) {
      setState(() {});
    }
  }

  void _logout() {
    Provider.of<UserService>(context, listen: false).logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final isLoggedIn = userService.isLoggedIn;
    final hasGoal = userService.hasGoal;

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // 콘텐츠 추가
          Column(
            children: [
              const SizedBox(height: 80),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.black.withOpacity(0.5),
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
                    const SizedBox(height: 80),
                    ElevatedButton(
                      key: Key('main_button'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        if (!isLoggedIn) {
                          _login();
                        } else if (!hasGoal) {
                          Navigator.pushNamed(context, '/goalInput');
                        } else {
                          Navigator.pushNamed(context, '/flower');
                        }
                      },
                      child: Text(
                        !isLoggedIn
                            ? 'Go to Login'
                            : !hasGoal
                            ? 'Set Goal'
                            : 'Go to Flower',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    if (isLoggedIn && hasGoal)
                      const SizedBox(height: 20),
                    if (isLoggedIn && hasGoal)
                      ElevatedButton(
                        key: Key('log_activity_button'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/activity_input');
                        },
                        child: const Text(
                          'Log Activity',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    if (isLoggedIn)
                      TextButton(
                        onPressed: _logout,
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
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