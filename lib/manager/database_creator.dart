import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const cartTable = 'cart';
  static const id = 'id';
  static const product_id = 'product_id';
  static const qte = 'qte';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createCartTable(Database db) async {
    final cartSql = '''CREATE TABLE $cartTable
    (
      $id INTEGER PRIMARY KEY,
      $product_id INTEGER NOT NULL,
      $qte INTEGER NOT NULL
    )''';

    await db.execute(cartSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
      print("Le repertoire de bdd existe");
    } else {
      await Directory(dirname(path)).create(recursive: true);
      print("Creation d'une nouvelle bdd oh ");
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('cart_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createCartTable(db);
  }
}
