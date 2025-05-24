import 'package:domain/entities/theme_mode_type.dart';
import 'package:domain/repositories/theme_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetThemeModeUseCase {
  final ThemeRepository _themeRepository;

  GetThemeModeUseCase(this._themeRepository);

  Future<ThemeModeType> call() async {
    return await _themeRepository.getTheme();
  }
}