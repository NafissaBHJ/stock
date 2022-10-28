import '../../modals/note_model.dart';
import '../../modals/user_model.dart';

abstract class StorageService {
  Future<void> init() async {}

  Future<List<dynamic>?> getRecord() async {}
  Future<void> insert(dynamic input) async {}
  Future<void> update(id, quantite, tests) async {}
  Future<void> delete(id) async {}
  Future<void> setUser(bool state) async {}
  Future<bool> getUser() async {
    return false;
  }

  Future<User?> getAdmin(String u,String p) async {}
}
