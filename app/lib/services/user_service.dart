import 'package:flutter/material.dart';

class UserService with ChangeNotifier {
  String _userName = 'User';
  bool _hasGoal = false;
  bool _isLoggedIn = false;

  String get userName => _userName;
  bool get hasGoal => _hasGoal;
  bool get isLoggedIn => _isLoggedIn;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setGoal(bool value) {
    _hasGoal = value;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = 'User';
    _hasGoal = false;
    notifyListeners();
  }
}