import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class DatabaseHelper {
  static const _dbName = "core.db";
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        // create tables
        await db.execute('''
          CREATE TABLE IF NOT EXISTS medications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            strength INT DEFAULT 0,
            sUnit TEXT DEFAULT "mg",
            icon TEXT NOT NULL,
            daily INT NOT NULL
          )
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            notificationId INTEGER,
            name TEXT NOT NULL,
            place TEXT DEFAULT "",
            note TEXT DEFAULT "",
            icon TEXT NOT NULL,
            reminder INT NOT NULL,
            date TEXT,
            time TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS reminders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            notificationId INTEGER,
            referenceId INT NOT NULL,
            pills INT DEFAULT 1,
            taken INT DEFAULT 0,
            time TEXT
          )
          ''');
      },
    );
  }

  // Insert
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch Data
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(table);
  }

  // Delete by Key
  Future<void> deleteAll(String table) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('''DELETE * FROM $table''');
  }

  // Delete by Key
  Future<void> deleteById(String table, int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('''DELETE FROM $table WHERE id = $id''');
  }

  // Delete by Reference
  Future<void> deleteByRef(String table, int ref) async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('''DELETE FROM $table WHERE referenceId = $ref''');
  }

  // Reset Reminders
  Future<void> resetReminders() async {
    final db = await DatabaseHelper.instance.database;
    await db.execute('''UPDATE reminders SET taken=0''');
  }
}
