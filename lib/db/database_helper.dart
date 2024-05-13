import 'dart:async';

import 'package:dhan_prabandh/db/model/account_model.dart';
import 'package:dhan_prabandh/db/model/category_model.dart';
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
    _db = await openDatabase(path,
        version: 3, onCreate: _createDB, onUpgrade: _onUpgrade);
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

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT CHECK(type IN ('income', 'expense')),
        parentId INTEGER,
        userId INTEGER,
        deleted INTEGER DEFAULT 0,  -- New column for soft deletion
        FOREIGN KEY (parentId) REFERENCES categories (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES SignUp (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE account (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        userId INTEGER,
        deleted INTEGER DEFAULT 0,
        isDefault INTEGER DEFAULT 0, 
        FOREIGN KEY (userId) REFERENCES SignUp (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      INSERT INTO account (name, isDefault) VALUES ('cash', 1), ('account', 1)
    ''');

    await db.execute('''
    INSERT INTO categories (name, type, isDefault) VALUES
      ('💰 Allowance', 'income', 1),
      ('💼 Salary', 'income', 1),
      ('💵 Petty cash', 'income', 1),
      ('🏅 Bonus', 'income', 1),
      ('🍜 Food', 'expense', 1),
      ('👬🏼 Social Life', 'expense', 1),
      ('🚖 Transport', 'expense', 1),
      ('🖼️ Culture', 'expense', 1),
      ('🪑 Household', 'expense', 1),
      ('🧥 Apparel', 'expense', 1),
      ('💄 Beauty', 'expense', 1),
      ('🧘🏽 Health', 'expense', 1),
      ('📙 Education', 'expense', 1),
      ('🎁 Gift', 'expense', 1);
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT CHECK(type IN ('income', 'expense')),
        parentId INTEGER,
        userId INTEGER,
        deleted INTEGER DEFAULT 0,  -- New column for soft deletion
        FOREIGN KEY (parentId) REFERENCES categories (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES SignUp (id) ON DELETE CASCADE
      )
    ''');
    }

    if (oldVersion < 3) {
      // Alter table to add new column in categories
      await db.execute(
          'ALTER TABLE categories ADD COLUMN isDefault INTEGER DEFAULT 0');
      // Create new table account
      await db.execute('''
      CREATE TABLE account (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        userId INTEGER,
        deleted INTEGER DEFAULT 0,
        isDefault INTEGER DEFAULT 0,  
        FOREIGN KEY (userId) REFERENCES SignUp (id) ON DELETE CASCADE
      )
    ''');

      // Insert default accounts
      await db.execute('''
        INSERT INTO account (name, isDefault) VALUES ('cash', 1), ('account', 1)
      ''');

      await db.execute('''
      INSERT INTO categories (name, type, isDefault) VALUES
        ('💰 Allowance', 'income', 1),
        ('💼 Salary', 'income', 1),
        ('💵 Petty cash', 'income', 1),
        ('🏅 Bonus', 'income', 1),
        ('🍜 Food', 'expense', 1),
        ('👬🏼 Social Life', 'expense', 1),
        ('🚖 Transport', 'expense', 1),
        ('🖼️ Culture', 'expense', 1),
        ('🪑 Household', 'expense', 1),
        ('🧥 Apparel', 'expense', 1),
        ('💄 Beauty', 'expense', 1),
        ('🧘🏽 Health', 'expense', 1),
        ('📙 Education', 'expense', 1),
        ('🎁 Gift', 'expense', 1);
     ''');
    }
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

  // login
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

  Future<int> insertCategory(Category category) async {
    Database dbClient = await db;
    return await dbClient.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategoriesByType(String type, int userId) async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'categories',
      where:
          'type = ? AND (userId = ? OR userId IS NULL) AND parentId IS NULL AND deleted = 0',
      whereArgs: [type, userId],
    );
    print('Retrieved data: $maps');
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
        parentId: maps[i]['parentId'],
        userId: maps[i]['userId'],
      );
    });
  }

  Future<void> deleteCategory(int id) async {
    Database dbClient = await db;
    await dbClient.update(
      'categories',
      {'deleted': 1}, // Set deleted flag to 1 (soft delete)
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getSubCategoriesByType(
      int parentId, int userId) async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'categories',
      where: 'parentId = ? AND userId = ? AND deleted = 0',
      whereArgs: [parentId, userId],
    );
    print('Retrieved data: $maps');
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
        parentId: maps[i]['parentId'],
        userId: maps[i]['userId'],
      );
    });
  }

  Future<int> updateCategory(Category category) async {
    Database dbClient = await db;
    return await dbClient.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> insertAccount(Account account) async {
    Database dbClient = await db;
    return await dbClient.insert('account', account.toMap());
  }

  Future<List<Account>> getAccounts(int? userId) async {
    Database dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient.query(
      'account',
      where: '(userId = ? OR userId IS NULL) AND deleted = 0',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Account.fromMap(maps[i]);
    });
  }

  Future<void> updateAccount(Account account) async {
    Database dbClient = await db;
    await dbClient.update(
      'account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteAccount(int accountId) async {
    Database dbClient = await db;
    await dbClient.update(
      'account',
      {'deleted': 1}, // Soft delete
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }
}
