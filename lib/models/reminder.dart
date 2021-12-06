import 'package:medsreminder/models/sqlobject.dart';

class Reminder implements SQLObject {

  final int? id;
  final String type;
  final int referenceId;
  final int daily;
  final String? date;
  final String time;

  Reminder({
    this.id,
    required this.type,
    required this.referenceId,
    required this.daily,
    this.date,
    required this.time,
  });

  @override
  Reminder.fromMap(Map<String, dynamic> res) :
    id = res["id"],
    type = res["type"],
    referenceId = res["referenceId"],
    daily = res["daily"],
    date = res["date"],
    time = res["time"];

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'type': type, 'referenceId': referenceId, 'daily': daily, 'date': date, 'time': time };
  }

  @override
  String toString() {
    return "Medication: { id: $id, type: $type, referenceId: $referenceId, daily: $daily, date: $date, time: $time }";
  }

}