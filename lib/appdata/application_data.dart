import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ApplicationData {
  /*
    ThemeData - Global theming constants
  */
  static ThemeData lightTheme = ThemeData();
  static ThemeData darkTheme = ThemeData();

  /*
    These are used in the medications form
  */
  // - - icons
  static Map<String, IconData> medsIcons = {
    'default': Icons.favorite,
    'home': Icons.home,
    'android': Icons.android,
    'album': Icons.album,
    'ac_unit': Icons.ac_unit,
  };

  static Map<String, IconData> appoIcons = {
    'default': Icons.circle,
  };

  // - - meds units
  static List<String> medsUnits = ["g", "mg", "μg", "ml", "cc", "mol", "mmol"];

  // - - days of the week
  static Map<int, String> daysOfTheWeek = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  // - - months
  static Map<int, String> months = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  // - - local notifications Theme Data
  static Map<String, Color?> notificationsColor = {
    "medication": Colors.pinkAccent,
    "appointment": Colors.lightBlue,
  };

  static Map<String, DrawableResourceAndroidBitmap?> notificationsIcons = {
    "medication": DrawableResourceAndroidBitmap('@drawable/app_icon'),
    "appointment": DrawableResourceAndroidBitmap('@drawable/app_icon'),
  };
}
