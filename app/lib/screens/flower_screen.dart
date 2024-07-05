import 'package:flutter/material.dart';

class FlowerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flower Pot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Flower',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/happypot.png', // 꽃 이미지 경로
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Watered: 3 times',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Growth: 2%',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 물주기 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You watered the flower!')),
                );
              },
              child: Text('Water the Flower'),
            ),
          ],
        ),
      ),
    );
  }
}