import 'package:shared_preferences/shared_preferences.dart';
import 'package:domain/entities/theme_mode_type.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/repositories/theme_repository.dart';

@LazySingleton(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences prefs;
  static const _key = 'theme_mode';

  ThemeRepositoryImpl(this.prefs);


  @override
  Future<ThemeModeType> getTheme() async {
    final saved = prefs.getString(_key);
    return ThemeModeType.values.firstWhere(
          (e) => e.name == saved,
      orElse: () => ThemeModeType.light,
    );
  }

  @override
  Future<void> setTheme(ThemeModeType theme) async {
    await prefs.setString(_key, theme.name);
  }
}

