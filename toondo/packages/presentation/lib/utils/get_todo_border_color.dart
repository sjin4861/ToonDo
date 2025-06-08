import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';

Color getBorderColor(Todo todo) {
    if (todo.importance == 1 && todo.urgency == 1) {
      return Color(0xffF8C0C1);
    } else if (todo.importance == 1 && todo.urgency == 0) {
      return Color(0xFFB0DFFB);
    } else if (todo.importance == 0 && todo.urgency == 1) {
      return Color(0xffFBEB9C);
    } else {
      return Color(0xffA9A29C);
    }
  }