import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvicer with ChangeNotifier {
  // - - default keys
  String _theme = "light";
  get theme => _theme;

  Future<void> switchTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? current = sharedPreferences.getString("theme");

    if (current == null) {
      _theme = "light";
    } else {
      _theme = (current == "light") ? "dark" : "light";
    }
    sharedPreferences.setString("theme", _theme);
    notifyListeners();
  }

  Future<String> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("theme") ?? "theme";
  }
}
