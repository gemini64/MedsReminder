import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationData {
  /*
    ThemeData - Global theming constants
  */
  static Map<String, ThemeData> theme = {
    "light": ThemeData(
        brightness: Brightness.light,
        textTheme: textTheme,
        dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal, brightness: Brightness.light)),
    "dark": ThemeData(
        brightness: Brightness.dark,
        textTheme: textTheme,
        dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal, brightness: Brightness.dark))
  };

  /*
    Custom material typescale
  */
  static TextTheme textTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    headline2: GoogleFonts.montserrat(
        fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    headline3:
        GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400),
    headline4: GoogleFonts.montserrat(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headline5:
        GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w500),
    headline6: GoogleFonts.montserrat(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    subtitle1: GoogleFonts.montserrat(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    subtitle2: GoogleFonts.montserrat(
        fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.1),
    bodyText1: GoogleFonts.rubik(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyText2: GoogleFonts.rubik(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    button: GoogleFonts.rubik(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    caption: GoogleFonts.rubik(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    overline: GoogleFonts.rubik(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );

  /*
    These are used in the medications form
  */
  // - - icons
  // static Map<String, IconData> medsIcons = {
  //   'default': Icons.favorite,
  //   'home': Icons.home,
  //   'android': Icons.android,
  //   'album': Icons.album,
  //   'ac_unit': Icons.ac_unit,
  // };

  static Map<int, String> pillsIcons = {
    0: "icons/pill-icon-1.png",
    1: "icons/pill-icon-2.png",
    2: "icons/pill-icon-3.png",
    3: "icons/pill-icon-4.png",
    4: "icons/pill-icon-5.png",
    5: "icons/pill-icon-6.png",
    6: "icons/pill-icon-7.png",
    7: "icons/pill-icon-8.png",
    8: "icons/pill-icon-9.png",
    9: "icons/pill-icon-10.png",
    10: "icons/pill-icon-11.png",
    11: "icons/pill-icon-12.png",
  };

  static Map<int, String> appoIcons = {
    0: "icons/appointment-icon.png",
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
    "medication": Colors.cyan,
    "appointment": Colors.deepOrangeAccent,
  };

  static Map<String, DrawableResourceAndroidBitmap?> notificationsIcons = {
    "medication": DrawableResourceAndroidBitmap('@drawable/pills_icon'),
    "appointment": DrawableResourceAndroidBitmap('@drawable/appointment_icon'),
  };
}
