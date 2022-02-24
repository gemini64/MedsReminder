import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medsreminder/main.dart';

class PreferencesProvider with ChangeNotifier {
  // - - default
  String _theme = currentTheme;
  get theme => _theme;

  Future<void> toggleChangeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? current = sharedPreferences.getString("theme");

    if (current == null) {
      _theme = (_theme == "light") ? "dark" : "light";
    } else {
      _theme = (current == "light") ? "dark" : "light";
    }
    await sharedPreferences.setString("theme", _theme);
    notifyListeners();
  }
}
