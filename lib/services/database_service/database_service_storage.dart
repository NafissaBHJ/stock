import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:stock/modals/history_model.dart';
import 'package:stock/modals/user_model.dart';
import 'package:stock/services/database_service/shared_preferences_storage.dart';

import '../../modals/data_model.dart';
import 'storage_service.dart';

class DatabaseServiceStorage extends StorageService {
  final _pProvider = ProductProvider();
  final userProvider = UserProvider();
  final historyProvider = HistoryProvider();
  String _path = "";
  var databaseFactory, db;
  @override
  Future<void> init() async {
    sqfliteFfiInit();
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactory = databaseFactoryFfi;
    var databasesPath = await getApplicationDocumentsDirectory();
    // var path = p.join(Directory.current.path, 'assets/db.sqlite');
    var path = p.join(databasesPath.path, 'db.sqlite');
    await open(path);
    _path = path;
    await createTables();
  }

  Future<void> open(String path) async {
    db = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            // onUpgrade: (db, oldVersion, newVersion) async {
            //   if (oldVersion < newVersion) {
            //     await db.execute('ALTER TABLE product ADD updated_at TEXT NULL');
            //   }
            // },
            ));
  }

  /*
   * Creates tables the first time only 
   */
  Future<void> createTables() async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
      CREATE TABLE if not exists product (
        id INTEGER PRIMARY KEY,
        produit TEXT,
        fournisseur TEXT,
        user TEXT,
        seuil INTEGER,
        quantite INTEGER,
        rest INTEGER,
        nb_test INTEGER,
        ht INTEGER,
        tva INTEGER,
        remise INTEGER,
        ttcu INTEGER,
        ttct INTEGER,
        fusion INTEGER,
        date_achat TEXT,
        date_peromp TEXT,
        period INTEGER NULL ,
        updated_at TEXT NULL


      )
    ''');
    await db.execute('''
      CREATE TABLE if not exists history(
        id INTEGER PRIMARY KEY,
        user TEXT,
        quantite INTEGER,
        product_id INTEGER REFERENCES product(id),
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE if not exists user (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT,
        job_id INTEGER
      )
    ''');

    List users = await db.query('user');

    if (users.isEmpty) {
      await db.rawInsert(
          'INSERT INTO user(username, password,job_id) VALUES(?, ?,?)',
          ["admin", "123aze", "1"]);
      await db.rawInsert(
          'INSERT INTO user(username, password,job_id) VALUES(?, ?,?)',
          ["user", "456aze", "2"]);
    }

    await db.close();
  }

  @override
  Future<List<dynamic>> getRecord() async {
    List<Product>? products = (await _pProvider.getAllProducts(_path));

    return products;
  }

  @override
  Future<void> insert(input) async {
    await _pProvider.insertProduct(input, _path);
  }

  @override
  Future<void> update(id, p) async {
    await _pProvider.updateProduct(_path, id, p);
  }

  @override
  Future<void> delete(id) async {
    await _pProvider.deleteProduct(id, _path);
    await historyProvider.deleteProductHistory(id, _path);
  }

  @override
  Future<User?> getAdmin(String u, String p) async {
    User? user = await userProvider.getUser(_path, u, p);
    return user;
  }

  @override
  Future<void> setUser(int state) async {
    SharedPreferenceStorage().setUser(state);
  }

  @override
  Future<int?> getUserP() {
    return SharedPreferenceStorage().getUserP();
  }

  @override
  Future<List<User>> getUsers() async {
    await open(_path);
    return userProvider.getUsers(_path);
  }

  @override
  Future<void> updateHistory(History h, int id, int productQ) async {
    await historyProvider.insertHistory(h, _path);
    await historyProvider.updateProduct(_path, id, productQ);
  }

  @override
  Future<void> updateHistoryEntry(History h) async {
    await historyProvider.insertHistory(h, _path);
  }

  @override
  Future<List<History>?> getHistory(int id) async {
    List<History>? hList = await historyProvider.getHistory(id, _path);
    return hList;
  }

  @override
  Future<void> insertUser(User user) async {
    await userProvider.insert(user, _path);
  }

  @override
  Future<void> updatePassword(int id, String str) async {
    await userProvider.updateUserPw(id, str, _path);
  }

  @override
  Future<void> deleteUser(int id) async {
    await userProvider.deleteUser(id, _path);
  }

  @override
  Future<void> deleteUserHistory(String name) async {
    await historyProvider.deleteUserHistory(name, _path);
  }

  @override
  Future<List?> getRecordByUser(String str) async {
    List? historyL = await historyProvider.getHistoryByUser(str, _path);

    return historyL;
  }

  @override
  Future<List<History>?> getHistoryByProduct(int id) async {
    List<History>? historyL =
        await historyProvider.getHistoryByProduct(id, _path) ?? [];

    return historyL;
  }

  @override
  Future<List?> searchProduct(String name) async {
    List<Product>? productSearch = await _pProvider.search(name, _path);
    return productSearch;
  }

  @override
  Future<List?> searchProductByDate(String date) async {
    List<Product>? productSearch =
        await _pProvider.searchProductByDate(date, _path);
    return productSearch;
  }

  @override
  Future<void> deleteRecordHistory(int id) async {
    await historyProvider.deleteRecordHistory(id, _path);
  }
}
