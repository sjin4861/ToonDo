import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';

// eisenhower 값을 기반으로 테두리 색상 결정
Color getBorderColor(Todo todo) {
  switch (todo.eisenhower) {
    case 0: // 중요하지 않고 긴급하지 않음
      return AppColors.brown300;
    case 1: // 중요하지 않지만 긴급함
      return AppColors.yellow300;
    case 2: // 중요하지만 긴급하지 않음
      return AppColors.blue300;
    case 3: // 중요하고 긴급함
      return AppColors.red300;
    default:
      return AppColors.brown300;
  }
}
