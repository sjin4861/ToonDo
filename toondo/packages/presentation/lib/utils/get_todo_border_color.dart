import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';

Color getBorderColor(Todo todo) {
    if (todo.importance == 1 && todo.urgency == 1) {
      return AppColors.red300;
    } else if (todo.importance == 1 && todo.urgency == 0) {
      return AppColors.blue300;
    } else if (todo.importance == 0 && todo.urgency == 1) {
      return AppColors.yellow300;
    } else {
      return AppColors.brown300;
    }
  }