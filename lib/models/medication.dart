import 'package:flutter/material.dart';
import 'package:medsreminder/models/sqlobject.dart';
import 'package:medsreminder/utils/utils.dart';

class Medication implements SQLObject {
  int? id;
  String name;
  int? strength;
  String? sUnit;
  int? icon;
  int daily;

  Medication(
      {this.id,
      required this.name,
      this.strength,
      this.sUnit,
      required this.icon,
      required this.daily});

  @override
  Medication.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        strength = res["strength"],
        sUnit = res["sUnit"],
        icon = res["icon"],
        daily = res["daily"];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'strength': strength,
      'sUnit': sUnit,
      'icon': icon,
      'daily': daily
    };
  }

  @override
  String toString() {
    return "Medication: { id: $id, name: $name, strength: $strength, sUnit: $sUnit, icon: $icon, daily: $daily }";
  }
}
