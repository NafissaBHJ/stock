import '../../modals/history_model.dart';
import '../../modals/user_model.dart';

abstract class StorageService {
  Future<void> init() async {}

  Future<List<dynamic>?> getRecord() async {}
  Future<void> insert(dynamic input) async {}
  Future<void> update(int id, pduct) async {}
  Future<void> delete(id) async {}
  Future<void> setUser(int state) async {}
  Future<int?> getUserP() async {}
  Future<User?> getAdmin(String u, String p) async {}
  Future<List<User>> getUsers() async {
    return [];
  }

  Future<void> updateHistory(History h, int id, int pq) async {}
  Future<void> updateHistoryEntry(
    History h,
  ) async {}

  Future<List<History>?> getHistory(int id) async {}
  Future<void> insertUser(User user) async {}
  Future<void> updatePassword(int id, String str) async {}

  Future<void> deleteUser(int id) async {}
  Future<void> deleteUserHistory(String name) async {}
  Future<void> deleteRecordHistory(int id) async {}

  Future<List<dynamic>?> getRecordByUser(String name) async {}

  Future<List<History>?> getHistoryByProduct(int id) async {}
  Future<List<dynamic>?> searchProduct(String name) async {}
}
