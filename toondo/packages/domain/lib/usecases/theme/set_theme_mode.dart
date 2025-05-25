import 'package:domain/entities/theme_mode_type.dart';
import 'package:domain/repositories/theme_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetThemeModeUseCase {
  final ThemeRepository _themeRepository;

  SetThemeModeUseCase(this._themeRepository);

  Future<void> call(ThemeModeType themeMode) async {
    await _themeRepository.setTheme(themeMode);
  }
}