import '../entities/theme_entity.dart';

class ToggleThemeUseCase {
  ThemeEntity call(bool isDarkTheme) {
    return ThemeEntity(isDarkTheme: !isDarkTheme);
  }
}
