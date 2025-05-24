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

  static ThemeModeType fromFlutterMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => ThemeModeType.light,
      ThemeMode.dark => ThemeModeType.dark,
      _ => ThemeModeType.light, // Default case
    };
  }
}