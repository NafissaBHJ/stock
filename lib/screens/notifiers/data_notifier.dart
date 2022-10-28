import 'package:flutter/cupertino.dart';
import '../../modals/note_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class DataNotifier extends ValueNotifier<List<Note>?> {
  final _storageService = getIt<StorageService>();

  DataNotifier() : super(note);

  static List<Note>? note;

  Future<void> initialize() async {
    await _storageService.init();
    await getData();
  }

  Future<void> getData() async {
    final List<Note> notes =
        (await _storageService.getRecord())?.cast<Note>() ?? [];

    _updateData(notes);
  }

  void _updateData(List<Note> mynotes) {
    value = mynotes;
  }

  void insertNote(Note note) {
    _storageService.insert(note);
  }
}
