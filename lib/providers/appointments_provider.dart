import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:medsreminder/models/appointment.dart';
import 'package:medsreminder/services/database_helper.dart';
import 'package:medsreminder/services/notification_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsProvider with ChangeNotifier {
  static const _tableName = 'appointments';
  List<Appointment> _appointments = [];
  List<Appointment> get appointments => [..._appointments];
  LinkedHashMap<DateTime, List<Appointment>> _events =
      LinkedHashMap<DateTime, List<Appointment>>(
    equals: isSameDay,
  );
  DateTime _initialDate = DateTime.now();
  DateTime _finalDate = DateTime.now();
  get initialDate => getInitial();
  get finalDate => getFinal();
  get events => _events;

  AppointmentsProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    final appoList = await DatabaseHelper.instance.getData(_tableName);

    _appointments = appoList.map((item) => Appointment.fromMap(item)).toList();
    _events.clear();
    buildHash();
    notifyListeners();
  }

  void buildHash() {
    for (Appointment appointment in _appointments) {
      DateTime key = DateTime.utc(appointment.date!.year,
          appointment.date!.month, appointment.date!.day);

      if (_events[key] == null) {
        _events[key] = [appointment];
      } else {
        _events[key]!.add(appointment);
      }

      // set initial/last date
      if (key.isBefore(_initialDate)) {
        _initialDate = key;
      }

      if (key.isAfter(_finalDate)) {
        _finalDate = key;
      }
    }
  }

  // Add
  Future<int> add(Appointment appointment) async {
    int lastId =
        await DatabaseHelper.instance.insert(_tableName, appointment.toMap());
    fetchData();
    notifyListeners();
    return lastId;
  }

  // Delete by ID
  Future delete(int id) async {
    for (int i = 0; i < _appointments.length; i++) {
      if (_appointments[i].id == id) {
        // unset notification
        if (_appointments[i].notificationId != null) {
          NotificationHelper()
              .cancelNotifications(_appointments[i].notificationId!);
        }

        // remove from internal list
        _appointments.removeAt(i);
      }
    }

    // rebuild hashmap (FIX)
    _events.clear();
    buildHash();

    notifyListeners();

    await DatabaseHelper.instance.deleteById(_tableName, id);
  }

  // Delete all
  Future deleteAll() async {
    // unset all notifications
    for (int i = 0; i < _appointments.length; i++) {
      // unset notification
      if (_appointments[i].notificationId != null) {
        NotificationHelper()
            .cancelNotifications(_appointments[i].notificationId!);
      }
    }

    // empty internal list and hashmap
    _appointments.clear();
    _events.clear();
    notifyListeners();

    await DatabaseHelper.instance.deleteAll(_tableName);
  }

  // Get element by id
  Appointment selectById(int id) {
    return _appointments.firstWhere((e) => e.id == id);
  }

  // Get element by id
  Appointment selectByNotificationId(int id) {
    return _appointments.firstWhere((e) => e.notificationId! == id);
  }

  // get initial date
  DateTime getInitial() {
    return DateTime(
        _initialDate.year, _initialDate.month - 3, _initialDate.day);
  }

  // get last date
  DateTime getFinal() {
    return DateTime(
        _initialDate.year, _initialDate.month + 3, _initialDate.day);
  }
}
