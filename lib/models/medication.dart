import 'package:medsreminder/models/sqlobject.dart';

class Medication implements SQLObject {

  final int? id;
  final String name;
  final double? strength;
  final String? sUnit;
  final String icon;
  final int refill;
  final int? remaining;
  final int daily;
  final int? reminderId;

  Medication({
    this.id,
    required this.name,
    this.strength,
    this.sUnit,
    required this.icon,
    required this.refill,
    this.remaining,
    required this.daily,
    this.reminderId
  });

  @override
  Medication.fromMap(Map<String, dynamic> res) :
    id = res["id"],
    name = res["name"],
    strength = res["strength"],
    sUnit = res["sUnit"],
    icon = res["icon"],
    refill = res["refill"],
    remaining = res["remaining"],
    daily = res["daily"],
    reminderId = res["reminderId"];

  @override
  Map<String, dynamic> toMap() {
    return {'id': id,'name': name, 'strength': strength, 'sUnit': sUnit, 'icon': icon, 'refill': refill, 'remaining': remaining, 'daily': daily, 'reminderId': reminderId };
  }

  @override
  String toString() {
    return "Medication: { id: $id, name: $name, strength: $strength, sUnit: $sUnit, icon: $icon, refill: $refill, remaining: $remaining, daily: $daily, reminderId: $reminderId }";
  }

}