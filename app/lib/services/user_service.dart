import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _goal;
  String? _character;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasGoal => _goal != null;
  String? get goal => _goal;
  String? get character => _character;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _goal = null;
    _character = null;
    notifyListeners();
  }

  void setGoal(String goal) {
    _goal = goal;
    notifyListeners();
  }

  void setCharacter(String character) {
    _character = character;
    notifyListeners();
  }
}