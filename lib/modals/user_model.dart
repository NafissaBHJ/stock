import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class User {
  int? id;
  int? jobId;
  String username;
  String password;

  User({this.id, required this.username, required this.password, this.jobId});
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "username": username,
      "password": password,
      "job_id": jobId
    };
    return map;
  }

  factory User.fromMap(dynamic map) {
    return User(
        id: map['id'],
        password: map['password'],
        username: map['username'],
        jobId: map['job_id']);
  }

  String replacePw() {
    return password.replaceRange(0, password.length, "*" * password.length);
  }

  String job() {
    return jobId == 1 ? "Admin" : "Utilisateur";
  }
}

class UserProvider {
  var db;

  late DatabaseFactory databaseFactorys;

  Future<void> openDb(String path) async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
  }

  Future<void> insert(User u, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = u.toMap();
    db.insert("user", value);
    await db.close();
  }

  Future<List<User>> getUsers(String path) async {
    await openDb(path);
    var users = await db.query('user');
    await db.close();
    return List<User>.from(users.map((e) => User.fromMap(e)).toList());
  }

  Future<User?> getUser(String path, String username, String pass) async {
    await openDb(path);
    User? u;
    List user = await db.rawQuery(
        'SELECT * FROM user WHERE username=? AND password=?', [username, pass]);

    if (user.isNotEmpty) {
      u = List<User>.from(user.map((e) => User.fromMap(e)).toList()).first;
    }
    await db.close();
    return u;
  }

  Future<void> updateUserPw(int id, String pw, String path) async {
    await openDb(path);
    int row = await db.rawUpdate('''
    UPDATE user 
    SET password = ?
    WHERE id = ?
    ''', [pw, id]);

    await db.close();
  }

  Future<void> deleteUser(int id, String path) async {
    await openDb(path);
    await db.delete("user", where: 'id = ?', whereArgs: [id]);
  }
}

typedef OnRowSelect = void Function(int index);

class UserDataSourceTable extends m.DataTableSource {
  UserDataSourceTable(
      {required this.list,
      required this.updatePw,
      required this.delete,
      required this.excel,
      required this.deleteH});
  List<User> list;
  final OnRowSelect updatePw;
  final OnRowSelect deleteH;
  final OnRowSelect delete;
  final OnRowSelect excel;
  @override
  m.DataRow? getRow(int index) {
    final row = list[index];
    return rowMethod(row, index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;

  DataRow2 rowMethod(User row, int index) {
    return DataRow2(specificRowHeight: 130, cells: [
      m.DataCell(Text(row.username)),
      m.DataCell(Text(row.replacePw())),
      m.DataCell(Text(row.job())),
      m.DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(
            child: const Text(
              "Modifier MP",
            ),
            onPressed: () => updatePw(index),
          ),
          Button(
            child: const Text(
              "Supprimer historique",
            ),
            onPressed: () => deleteH(index),
          ),
          Button(
            child: const Text(
              "Supprimer",
            ),
            onPressed: () => delete(index),
          ),
          Button(child: const Text(' Excel '), onPressed: (() => excel(index)))
        ],
      ))
    ]);
  }
}
