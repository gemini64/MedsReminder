import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/models/appointment.dart';
import 'package:medsreminder/models/reminder.dart';

class DatabaseHandler {

  // setup database - connect and create tables
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'core.db'),
      onCreate: (database, version) async {
        // create tables
        await database.execute(
          '''
          CREATE TABLE IF NOT EXISTS medications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            strength REAL DEFAULT 0,
            sUnit TEXT DEFAULT "",
            icon TEXT NOT NULL,
            refill INT NOT NULL,
            remaining INT DEFAULT 0,
            daily INT NOT NULL,
            reminderId INT DEFAULT 0
          )
          '''
        );
        await database.execute(
          '''
          CREATE TABLE IF NOT EXISTS  appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            place TEXT DEFAULT "",
            note TEXT DEFAULT "",
            reminder INT NOT NULL,
            reminderId INT DEFAULT 0,
            datetime TEXT NOT NULL
          )
          '''
        );
        await database.execute(
          '''
          CREATE TABLE IF NOT EXISTS  reminders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            referenceId INT NOT NULL,
            daily INT NOT NULL,
            date TEXT DEFAULT "",
            time INT NOT NULL
          )
          '''
        );
      },
      version: 1,
    );
  }

  // insert med
  Future<int> insertMeds(List<Medication> medications) async {
    int result = 0;
    final Database db = await initializeDB();

    for(var medication in medications){
      result = await db.insert('medications', medication.toMap());
    }
    return result;
  }

  // insert appointment
  Future<int> insertAppointments(List<Appointment> appointments) async {
    int result = 0;
    final Database db = await initializeDB();

    for(var appointment in appointments){
      result = await db.insert('appointments', appointment.toMap());
    }
    return result;
  }

  // insert reminders
  Future<int> insertReminders(List<Reminder> reminders) async {
    int result = 0;
    final Database db = await initializeDB();

    for(var reminder in reminders){
      result = await db.insert('reminders', reminder.toMap());
    }
    return result;
  }

  // delete med
  Future<void> deleteMed(int id) async {
    final db = await initializeDB();
    // cleanup medication and connected reminders
    await db.execute(
      '''
      DELETE FROM medications WHERE id = $id;
      DELETE FROM reminders WHERE type = 'medication' AND referenceId = $id;
      '''
    );
  }

  // delete appointment
  Future<void> deleteAppoinment(int id) async {
    final db = await initializeDB();
    // cleanup medication and connected reminders
    await db.execute(
      '''
      DELETE FROM appointments WHERE id = $id;
      DELETE FROM reminders WHERE type = 'appointment' AND referenceId = $id;
      '''
    );
  }

  // delete reminder
  Future<void> deleteReminder(int id) async {
    final db = await initializeDB();
    await db.execute(
      '''
      DELETE FROM reminders WHERE id = $id;
      '''
    );
  }

  Future<List<Appointment>> retrieveAppointments() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('appointments');
    return queryResult.map((e) => Appointment.fromMap(e)).toList();
  }

}