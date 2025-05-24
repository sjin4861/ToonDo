import 'package:domain/entities/theme_mode_type.dart';

abstract class ThemeRepository {
  Future<void> setTheme(ThemeModeType theme);
  Future<ThemeModeType> getTheme();
}