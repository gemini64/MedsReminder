import 'package:flutter/material.dart';
import 'package:medsreminder/models/sqlobject.dart';
import 'package:medsreminder/utils/utils.dart';

class Appointment implements SQLObject {
  int? id;
  int? notificationId;
  String name;
  String? place;
  String? note;
  IconData? icon;
  int reminder;
  DateTime? date;
  TimeOfDay? time;

  Appointment(
      {this.id,
      this.notificationId,
      required this.name,
      this.place,
      this.note,
      required this.icon,
      required this.reminder,
      this.date,
      this.time});

  @override
  Appointment.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        notificationId = res["notificationId"],
        name = res["name"],
        place = res["place"],
        note = res["note"],
        icon = Utils.parseIcon(res["icon"]),
        reminder = res["reminder"],
        date = Utils.parseDate(res["date"]),
        time = Utils.parseTime(res["time"]);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationId': notificationId,
      'name': name,
      'place': place,
      'note': note,
      'icon': Utils.iconToString(icon),
      'reminder': reminder,
      'date': Utils.dateToString(date),
      'time': Utils.timeToString(time)
    };
  }

  @override
  String toString() {
    return "Appointment: { id: $id, notificationId: $notificationId, name: $name, place: $place, note: $note, icon: $icon, reminder: $reminder, date: $date, time: $time }";
  }
}
