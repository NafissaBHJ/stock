import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
 * 
 *  Model for saving users consumption logs 
 * 
 */
class History {
  int? id;
  String? name;
  int? quantite;
  int? productid;
  String? date;

  History(this.productid, this.name, this.quantite, this.date);
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "user": name,
      "quantite": quantite,
      "product_id": productid,
      "date": date
    };
    return map;
  }

  factory History.fromMap(dynamic map) {
    return History(map['id'], map['user'], map['quantite'], map['date']);
  }
}

class HistoryProvider {
  late var db;
  late DatabaseFactory databaseFactorys;

  Future<void> insertHistory(History h, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = h.toMap();
    db.insert("history", value);
    await db.close();
  }

  Future<void> updateProduct(String path, int id, int quantite) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    int row = await db.rawUpdate('''
    UPDATE product 
    SET rest = ?
    WHERE id = ?
    ''', [quantite, id]);

    await db.close();
  }

  Future<List<History>> getHistory(int id, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var productH =
        await db.rawQuery('SELECT  * FROM history WHERE product_id =?', [id]);
    await db.close();
    return List<History>.from(productH.map((e) => History.fromMap(e)).toList());
  }

  Future<int> deleteProductHistory(int id, String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    return await db.delete("history", where: 'product_id = ?', whereArgs: [id]);
  }

  Future<int> deleteUserHistory(String name, String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    return await db.delete("history", where: 'user = ?', whereArgs: [name]);
  }
}
