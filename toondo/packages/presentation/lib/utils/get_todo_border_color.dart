import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';

Color getBorderColor(Todo todo) {
    if (todo.importance == 1 && todo.urgency == 1) {
      return Colors.red;
    } else if (todo.importance == 1 && todo.urgency == 0) {
      return Colors.blue;
    } else if (todo.importance == 0 && todo.urgency == 1) {
      return Colors.yellow;
    } else {
      return Colors.black;
    }
  }