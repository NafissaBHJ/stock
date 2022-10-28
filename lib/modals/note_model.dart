
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const String noteTable = "Note";
const String columnId = "id";
const String columnTitle = "title";
const String columnBody = "body";
const String columnCreatedAt = "created_at";
const String columnUpdatedAt = "updated_at";

class Note {
  int? id;
  String title;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note(
      {this.id,
      required this.title,
      this.body,
      this.createdAt,
      this.updatedAt});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnBody: body,
      columnCreatedAt: createdAt.toString(),
      columnUpdatedAt: updatedAt.toString()
    };
    return map;
  }

  factory Note.fromMap(dynamic map) {
    return Note(
      id: map[columnId] as int?,
      title: map[columnTitle] as String,
      body: map[columnBody] as String?,
      createdAt: DateTime.parse(map[columnCreatedAt]),
      updatedAt: DateTime.parse(map[columnCreatedAt]),
    );
  }
}

class NoteProvider {
  late var db;
  late String _path;
  late DatabaseFactory databaseFactorys;

  Future<void> createDb(String path) async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
  }

  Future<List<Note>> getNotesRecords(String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var notes = await db.query('Note');
    //var notes = await db.rawDelete('DELETE  FROM Note');
    await db.close();
    return List<Note>.from(notes.map((e) => Note.fromMap(e)).toList());
  }

  Future<void> insertRecord(Note note, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = note.toMap();

    db.insert(noteTable, value);
  }
}
