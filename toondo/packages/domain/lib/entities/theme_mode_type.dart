import 'package:flutter/material.dart';

enum ThemeModeType { light, dark }

extension ThemeModeTypeX on ThemeModeType {
  ThemeMode toFlutterMode() {
    switch (this) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
    }
  }

  String get label {
    switch (this) {
      case ThemeModeType.light:
        return '라이트';
      case ThemeModeType.dark:
        return '다크';
    }
  }

  static ThemeModeType fromFlutterMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => ThemeModeType.light,
      ThemeMode.dark => ThemeModeType.dark,
      _ => ThemeModeType.light, // Default case
    };
  }
}
