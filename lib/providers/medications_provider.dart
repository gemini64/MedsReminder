import 'package:flutter/foundation.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/services/database_helper.dart';

class MedicationsProvider with ChangeNotifier {
  static const _tableName = 'medications';
  List<Medication> _medications = [];
  List<Medication> get medications => [..._medications];

  MedicationsProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    final medsList = await DatabaseHelper.instance.getData(_tableName);

    _medications = medsList.map((item) => Medication.fromMap(item)).toList();
    notifyListeners();
  }

  // Get Medications by Type (daily/asneeded)
  List<Medication> byType(String type) {
    List<Medication> myList = [];
    if (type == "asneeded") {
      for (Medication item in _medications) {
        if (item.daily == 0) {
          myList.add(item);
        }
      }
    }
    if (type == "daily") {
      for (Medication item in _medications) {
        if (item.daily == 1) {
          myList.add(item);
        }
      }
    }
    return myList;
  }

  // Add
  Future<int> add(Medication medication) async {
    int newId =
        await DatabaseHelper.instance.insert(_tableName, medication.toMap());
    fetchData();
    notifyListeners();

    return newId;
  }

  // Delete by ID
  Future delete(int id) async {
    _medications.removeWhere((e) => e.id == id);
    notifyListeners();

    await DatabaseHelper.instance.deleteById(_tableName, id);
  }

  // Delete all
  Future deleteAll() async {
    _medications.clear();
    notifyListeners();

    await DatabaseHelper.instance.deleteAll(_tableName);
  }

  // Get element by id
  Medication selectById(int id) {
    return _medications.firstWhere((e) => e.id == id);
  }
}
