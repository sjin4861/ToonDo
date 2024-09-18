// lib/utils/color_utils.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';

Color getColor(Todo todo) {
  if (todo.urgency >= 5.0 && todo.importance >= 5.0) {
    return Colors.redAccent;
  } else if (todo.urgency < 5.0 && todo.importance >= 5.0) {
    return Colors.orangeAccent;
  } else if (todo.urgency >= 5.0 && todo.importance < 5.0) {
    return Colors.lightBlueAccent;
  } else {
    return Colors.greenAccent;
  }
}