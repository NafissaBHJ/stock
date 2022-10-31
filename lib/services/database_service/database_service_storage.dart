import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:stock/modals/user_model.dart';

import '../../modals/data_model.dart';
import 'storage_service.dart';

class DatabaseServiceStorage extends StorageService {
  final _pProvider = ProductProvider();
  final userProvider = UserProvider();
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
    var exists = await databaseFactory.databaseExists(path);
    print(exists);
    db = await databaseFactory.openDatabase(path);
    // db.getVersion().then((value){});
    if (exists == false) {
      _pProvider.createDb(path);
      await createTables();
    } else {
      _path = path;
      await createTables();
    }
  }

  Future<void> createTables() async {
    await db.execute('''
      CREATE TABLE if not exists product (
        id INTEGER PRIMARY KEY,
        produit TEXT,
        fournisseur TEXT,
        user TEXT,
        seuil INTEGER,
        quantite INTEGER,
        nb_test INTEGER,
        ht INTEGER,
        tva INTEGER,
        remise INTEGER,
        ttc INTEGER,
        date_achat TEXT,
        date_peromp TEXT 
      )
    ''');
    await db.execute('''
      CREATE TABLE if not exists user (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');

    List notes = await db.query('user');
    if (notes.isEmpty) {
      db.rawInsert('INSERT INTO user(username, password) VALUES(?, ?)',
          ["admin", "123aze"]);
    }
  }

/*   Future<List<Note>> getNotesRecords(String path) async {
    await databaseFactory.openDatabase(path);
    var notes = await db.query('Note');
    print(notes);
    List<Note> list = notes.map((e) => Note.fromMap(e)).toList();
    await db.close();
    return list;
  }
 */
  @override
  Future<List<dynamic>> getRecord() async {
    List<Product>? products = (await _pProvider.getAllProducts(_path));
    print("here $products");
    return products;
  }

  @override
  Future<void> insert(input) async {
    print('here product $input');
    await _pProvider.insertProduct(input, _path);
  }

  @override
  Future<void> update(id, quantite, tests) async {
    await _pProvider.updateProduct(_path, id, quantite, tests);
  }

  @override
  Future<void> delete(id) async {
    await _pProvider.deleteProduct(id, _path);
  }

  Future<User?> getAdmin(String u, String p) async {
    User? user = await userProvider.getUser(_path, u, p);
    return user;
  }
}
