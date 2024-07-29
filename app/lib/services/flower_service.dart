import 'package:flutter/material.dart';

class Flower {
  String name;
  int growth;
  int damage;
  int evolutionStage;
  int level;

  Flower({
    required this.name,
    this.growth = 0,
    this.damage = 0,
    this.evolutionStage = 1,
    this.level = 1,
  });

  bool get canEvolve => growth >= 100 && evolutionStage < 3;

  void grow() {
    if (damage == 0) {
      growth += 10;
      if (canEvolve) {
        evolve();
      }
    }
  }

  void takeDamage() {
    damage += 10;
    if (damage >= 50) {
      growth = (growth - 20 < 0) ? 0 : growth - 20;
    }
  }

  void evolve() {
    if (canEvolve) {
      evolutionStage += 1;
      level += 1;  // 진화 시 레벨 증가
      growth = 0;
      damage = 0;
    }
  }
}

class FlowerService with ChangeNotifier {
  Flower _flower;

  FlowerService(String name)
      : _flower = Flower(name: name);

  Flower get flower => _flower;

  void growFlower() {
    _flower.grow();
    notifyListeners();
  }

  void damageFlower() {
    _flower.takeDamage();
    notifyListeners();
  }

  void resetFlower() {
    _flower = Flower(name: _flower.name);
    notifyListeners();
  }
}