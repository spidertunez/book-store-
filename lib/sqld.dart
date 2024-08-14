import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'Nagham.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("onUpgrade========");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE book (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
    print("onCreate ===============");
  }

  Future<List<Map>> readData(String sql, [List<Object>? arguments]) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql, arguments);
    return response;
  }

  Future<int> insertData(String sql, [List<Object>? arguments]) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, arguments);
    return response;
  }

  Future<int> deleteData(String sql, [List<Object>? arguments]) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql, arguments);
    return response;
  }

  Future<int> updateData(String sql, [List<Object>? arguments]) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql, arguments);
    return response;
  }
}
