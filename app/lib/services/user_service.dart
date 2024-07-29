import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _goal;
  String? _character;
  int _wateredCount = 0; // 물주기 횟수
  final int _maxWaterCount = 3; // 하루에 줄 수 있는 최대 물 횟수

  bool get isLoggedIn => _isLoggedIn;
  bool get hasGoal => _goal != null;
  String? get goal => _goal;
  String? get character => _character;
  int get wateredCount => _wateredCount;
  int get maxWaterCount => _maxWaterCount;
  double get growthPercentage => (_wateredCount / _maxWaterCount) * 100;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _goal = null;
    _character = null;
    _wateredCount = 0;
    notifyListeners();
  }

  Future<dynamic> setGoal(String goal) async{
    _goal = goal;
    notifyListeners();
  }

  void setCharacter(String character) {
    _character = character;
    notifyListeners();
  }

  void waterFlower() {
    if (_wateredCount < _maxWaterCount) {
      _wateredCount += 1;
      notifyListeners();
    }
  }

  void resetWatering() {
    _wateredCount = 0;
    notifyListeners();
  }
}