import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:medsreminder/services/database_helper.dart';
import 'package:medsreminder/services/notification_helper.dart';

class RemindersProvider with ChangeNotifier {
  static const _tableName = 'reminders';
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => [..._reminders];

  RemindersProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    final remsList = await DatabaseHelper.instance.getData(_tableName);

    _reminders = remsList.map((item) => Reminder.fromMap(item)).toList();
    notifyListeners();
  }

  // Get Reminders by Ref
  List<Reminder> selectByRef(int ref) {
    List<Reminder> myList = [];
    for (Reminder reminder in _reminders) {
      if (reminder.referenceId == ref) {
        myList.add(reminder);
      }
    }

    return myList;
  }

  // Add
  Future add(Reminder reminder) async {
    await DatabaseHelper.instance.insert(_tableName, reminder.toMap());
    fetchData();
    notifyListeners();
  }

  // Delete by ID
  Future delete(int id) async {
    for (int i = 0; i < _reminders.length; i++) {
      if (_reminders[i].id == id) {
        // unset notification
        if (_reminders[i].notificationId != null) {
          NotificationHelper()
              .cancelNotifications(_reminders[i].notificationId!);
        }

        // remove from internal list
        _reminders.removeAt(i);
      }
    }
    notifyListeners();

    await DatabaseHelper.instance.deleteById(_tableName, id);
  }

  // Delete by Ref
  Future deleteByRef(int ref) async {
    for (int i = 0; i < _reminders.length; i++) {
      if (_reminders[i].referenceId == ref) {
        // unset notification
        if (_reminders[i].notificationId != null) {
          NotificationHelper()
              .cancelNotifications(_reminders[i].notificationId!);
        }

        // remove from internal list
        _reminders.removeAt(i);
      }
    }
    notifyListeners();

    await DatabaseHelper.instance.deleteByRef(_tableName, ref);
  }

  // Delete all
  Future deleteAll() async {
    // unset all notifications
    for (int i = 0; i < _reminders.length; i++) {
      // unset notification
      if (_reminders[i].notificationId != null) {
        NotificationHelper().cancelNotifications(_reminders[i].notificationId!);
      }
    }

    // clear internal list
    _reminders.clear();
    notifyListeners();

    await DatabaseHelper.instance.deleteAll(_tableName);
  }

  // Get element by id
  Reminder selectByNotificationId(int id) {
    return _reminders.firstWhere((e) => e.notificationId! == id);
  }

  // Get element by id
  Reminder selectById(int id) {
    return _reminders.firstWhere((e) => e.id == id);
  }

  // reset reminders
  Future resetReminders() async {
    await DatabaseHelper.instance.resetReminders();

    fetchData();
    notifyListeners();
  }
}
