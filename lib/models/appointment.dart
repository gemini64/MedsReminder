import 'package:medsreminder/models/sqlobject.dart';

class Appointment implements SQLObject {

  final int? id;
  final String name;
  final String? place;
  final String? note;
  final int reminder;
  final int? reminderId;
  final String datetime;

  Appointment({
    this.id,
    required this.name,
    this.place,
    this.note,
    required this.reminder,
    this.reminderId,
    required this.datetime
  });

  @override
  Appointment.fromMap(Map<String, dynamic> res) :
    id = res["id"],
    name = res["name"],
    place = res["place"],
    note = res["note"],
    reminder = res["reminder"],
    reminderId = res["reminderId"],
    datetime = res["datetime"];

  @override
  Map<String, dynamic> toMap() {
    return {'id': id,'name': name, 'place': place, 'note': note, 'reminder': reminder, 'reminderId': reminderId, 'datetime': datetime };
  }

  @override
  String toString() {
    return "Appointment: { id: $id, name: $name, place: $place, note: $note, reminder: $reminder, reminderId: $reminderId, datetime: $datetime }";
  }

}