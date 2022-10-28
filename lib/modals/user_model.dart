import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class User {
  int? id;
  String username;
  String password;

  User({required this.username, required this.password});
  Map<String, Object?> toMap() {
    var map = <String, Object?>{"username": username, "password": password};
    return map;
  }

  factory User.fromMap(dynamic map) {
    return User(password: map['password'], username: map['username']);
  }
}

class UserProvider {
  late var db;
  late String _path;
  late DatabaseFactory databaseFactorys;

  Future<void> createDb(String path) async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
  }

  Future<void> insert(User u, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = u.toMap();
    db.insert("user", value);
  }

  Future<User?> getUser(String path, String username, String pass) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    User? u;
    List user = await db.rawQuery(
        'SELECT * FROM user WHERE username=? AND password=?', [username, pass]);
    print(user.isNotEmpty);
    if (user.isNotEmpty) {
      u = List<User>.from(user.map((e) => User.fromMap(e)).toList()).first;
    }
    await db.close();
    return u;
  }
}