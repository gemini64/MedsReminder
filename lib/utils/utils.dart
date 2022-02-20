import 'dart:convert';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter/material.dart';

class Utils {
  // String conversion helpers - used to communicate with db

  // - - IconData
  static String? iconToString(IconData? icon) {
    if (icon != null) {
      dynamic map = serializeIcon(icon);
      return jsonEncode(map);
    } else {
      return null;
    }
  }

  static IconData? parseIcon(String? str) {
    if (str != null) {
      dynamic map = jsonDecode(str);
      return deserializeIcon(map);
    } else {
      return null;
    }
  }

  // - - TimeOfDay
  static String? timeToString(TimeOfDay? time) {
    if (time != null) {
      return time.toString();
    } else {
      return null;
    }
  }

  static TimeOfDay? parseTime(String? str) {
    if (str != null) {
      String time = str.split("(")[1].split(")")[0];
      return TimeOfDay(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1]));
    } else {
      return null;
    }
  }

  // - - DateTime
  static String? dateToString(DateTime? date) {
    if (date != null) {
      return date.toIso8601String();
    } else {
      return null;
    }
  }

  static DateTime? parseDate(String? str) {
    if (str != null) {
      return DateTime.parse(str);
    } else {
      return null;
    }
  }

  // - - Pretty printers
  static String prettyDate(DateTime? date) {
    if (date != null) {
      String d = date.day.toString();
      String m = date.month.toString();
      String y = date.year.toString();
      d = (d.length == 1 ? "0" : "") + d;
      m = (m.length == 1 ? "0" : "") + m;
      return d + "-" + m + "-" + y;
    } else {
      return "";
    }
  }

  static String prettyTime(TimeOfDay? time) {
    if (time != null) {
      String h = time.hour.toString();
      String m = time.minute.toString();
      h = (h.length == 1 ? "0" : "") + h;
      m = (m.length == 1 ? "0" : "") + m;
      return h + ":" + m;
    } else {
      return "";
    }
  }

  // Date and time conversion

  // TimeOfDay to DateTime
  static DateTime timeToDate(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  // Merge DateTime and TimeOfDay
  static DateTime timeAndDate(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
