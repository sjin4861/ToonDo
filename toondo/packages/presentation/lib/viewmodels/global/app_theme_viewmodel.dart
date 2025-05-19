import 'package:domain/entities/theme_mode_type.dart';
import 'package:domain/usecases/theme/get_theme_mode.dart';
import 'package:domain/usecases/theme/set_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppThemeViewModel extends ChangeNotifier {
  final GetThemeModeUseCase getThemeMode;
  final SetThemeModeUseCase setThemeMode;

  ThemeModeType _mode = ThemeModeType.light;
  ThemeModeType get mode => _mode;

  AppThemeViewModel(this.getThemeMode, this.setThemeMode);

  Future<void> load() async {
    _mode = await getThemeMode();
    notifyListeners();
  }

  Future<void> update(ThemeModeType newMode) async {
    _mode = newMode;
    print('[AppThemeViewModel] update called with: $newMode'); // 로그 추가
    await setThemeMode(newMode);
    notifyListeners();
  }
}
