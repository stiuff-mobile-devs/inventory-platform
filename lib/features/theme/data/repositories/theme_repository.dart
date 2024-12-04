// import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  final SharedPreferences sharedPreferences;

  ThemeRepository({required this.sharedPreferences});

  Future<void> saveThemePreference(bool isDarkTheme) async {
    await sharedPreferences.setBool('isDarkTheme', isDarkTheme);
  }

  bool getThemePreference() {
    return sharedPreferences.getBool('isDarkTheme') ?? false;
  }
}
