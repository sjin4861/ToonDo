import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

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
            Container(
              height: 200,
              child: RiveAnimation.asset(
                'assets/animations/flower_animation.riv',
              ),
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