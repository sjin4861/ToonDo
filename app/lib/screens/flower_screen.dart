import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../services/user_service.dart';

class FlowerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final String? characterName = userService.character;
    final String flowerName = characterName ?? 'Unnamed Flower'; // Default name if no character name

    return Scaffold(
      appBar: AppBar(
        title: Text('My Flower Pot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$flowerName (Level 1)', // Placeholder for level, assuming level is 1
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: Image.asset('assets/images/level1_pot.png')
            ),
            SizedBox(height: 20),
            Text(
              'Watered: ${userService.wateredCount} times',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Growth: ${userService.growthPercentage}%',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (userService.wateredCount < userService.maxWaterCount) {
                  userService.waterFlower();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You watered the flower!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No water left! Try again tomorrow.')),
                  );
                }
              },
              child: Text('Water the Flower'),
            ),
          ],
        ),
      ),
    );
  }
}