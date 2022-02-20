import 'package:flutter/material.dart';
import 'package:medsreminder/models/sqlobject.dart';
import 'package:medsreminder/utils/utils.dart';

class Reminder implements SQLObject {
  int? id;
  int? notificationId;
  int referenceId;
  int? pills;
  int? taken;
  TimeOfDay? time;

  Reminder({
    this.id,
    this.notificationId,
    required this.referenceId,
    this.pills,
    this.taken,
    this.time,
  });

  @override
  Reminder.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        notificationId = res["notificationId"],
        referenceId = res["referenceId"],
        pills = res["pills"],
        taken = res["taken"],
        time = Utils.parseTime(res["time"]);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationId': notificationId,
      'referenceId': referenceId,
      'pills': pills,
      'taken': taken,
      'time': Utils.timeToString(time)
    };
  }

  @override
  String toString() {
    return "Reminder: { id: $id, notificationId: $notificationId, referenceId: $referenceId, pills: $pills, taken: $taken, time: $time }";
  }
}
