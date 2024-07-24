import 'package:flutter/material.dart';

class CharacterMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String goal = ModalRoute.of(context)!.settings.arguments as String;
    final String character = matchCharacter(goal);

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
            Text(
              'Matched Character: $character',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40), // 버튼과 텍스트 사이의 간격을 위해 추가
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
    // 목표에 따라 식물 캐릭터를 선택하는 로직
    if (goal.contains('fitness')) {
      return 'Cactus';
    } else if (goal.contains('study')) {
      return 'Sunflower';
    } else {
      return 'Fern';
    }
  }
}