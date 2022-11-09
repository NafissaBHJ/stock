import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});
  Map<String, Object?> toMap() {
    var map = <String, Object?>{"username": username, "password": password};
    return map;
  }

  factory User.fromMap(dynamic map) {
    return User(
        id: map['id'], password: map['password'], username: map['username']);
  }
}

class UserProvider {
  var db;

  late DatabaseFactory databaseFactorys;

  Future<void> createDb(String path) async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    print(path);
    db = await databaseFactory.openDatabase(path);
  }

  Future<void> insert(User u, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = u.toMap();
    db.insert("user", value);
  }

  Future<User?> getUser(String path, String username, String pass) async {
    await createDb(path);
    // print(path);
    List notes = await db.query('user');
    print(notes);
    User? u;
    List user = await db.rawQuery(
        'SELECT * FROM user WHERE username=? AND password=?', [username, pass]);

    if (user.isNotEmpty) {
      u = List<User>.from(user.map((e) => User.fromMap(e)).toList()).first;
    }
    await db.close();
    return u;
  }
}
