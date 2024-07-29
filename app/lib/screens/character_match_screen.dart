import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';

class CharacterMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String goal = ModalRoute.of(context)!.settings.arguments as String;
    final String character = matchCharacter(goal);

    final userService = Provider.of<UserService>(context, listen: false);
    userService.setCharacter(character);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Matched Character'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Goal: $goal',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/level1_pot.png'),
            Text(
              'Matched Character: $character',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Name your character',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (name) {
                  if (name.isNotEmpty) {
                    userService.setCharacter(name); // 저장 로직
                    FocusScope.of(context).unfocus(); // 키보드 숨기기
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  } else {
                    // 유효하지 않은 입력에 대한 처리
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a valid name.'),
                    ));
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  String matchCharacter(String goal) {
    // Match the character based on the user's goal
    if (goal.contains('fitness')) {
      return 'Cactus';
    } else if (goal.contains('study')) {
      return 'Sunflower';
    } else {
      return 'Fern';
    }
  }
}