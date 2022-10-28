import 'package:flutter/cupertino.dart';
import 'package:stock/modals/note_model.dart';
import 'package:stock/screens/notifiers/data_notifier.dart';

class MyNotesPageManager {
  final dataNotifier = DataNotifier();

  void initDataState() async {
    //await dataNotifier.initialize();
  }

  void adding() {
    Note note = Note(
        title: "this is a note",
        body: "ok this is a text in the note",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    print("we are here");
    var val = dataNotifier.value;
    dataNotifier.value = [...val!]..add(note);
    dataNotifier.insertNote(note);
  }
}
