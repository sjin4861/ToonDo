import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/viewmodels/global/app_theme_viewmodel.dart';

@injectable
class DisplaySettingViewModel extends ChangeNotifier {
  final AppThemeViewModel _themeVM = GetIt.instance<AppThemeViewModel>();

  ThemeModeType? _mode;
  ThemeModeType get currentMode => _mode!;
  bool get isLoaded => _mode != null;

  Future<void> load() async {
    _mode = await _themeVM.getThemeMode();
    notifyListeners();
  }

  void selectMode(ThemeModeType mode) {
    _mode = mode;
    _themeVM.update(mode);
    notifyListeners();
  }
}