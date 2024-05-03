import 'dart:async';

import 'package:dhan_prabandh/db/model/sign_up_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'signup.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDB);
    return _db!;
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE SignUp (
        id INTEGER PRIMARY KEY,
        name TEXT,
        surname TEXT,
        password TEXT
      )
      ''');
  }

  Future<int> insertSignUp(SignUp signUp) async {
    Database dbClient = await db;
    return await dbClient.insert('SignUp', signUp.toMap());
  }

  Future<bool> isPasswordUnique(String password) async {
    Database dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'SignUp',
      where: 'password = ?',
      whereArgs: [password],
    );
    return result.isEmpty;
  }

  Future<List<SignUp>> getAllSignUps() async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('SignUp');
    return List.generate(maps.length, (i) {
      return SignUp(
        id: maps[i]['id'],
        name: maps[i]['name'],
        surname: maps[i]['surname'],
        password: maps[i]['password'],
      );
    });
  }

  Future<SignUp?> findUserByPassword(String password) async {
    final Database dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'SignUp',
      where: 'password = ?',
      whereArgs: [password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return SignUp(
        id: result[0]['id'],
        name: result[0]['name'],
        surname: result[0]['surname'],
        password: result[0]['password'],
      );
    } else {
      return null;
    }
  }
}
