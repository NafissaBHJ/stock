import 'package:flutter/cupertino.dart';

import '../../modals/user_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class UserNotifier extends ValueNotifier<List<User>> {
  UserNotifier() : super([]);
  final storageService = getIt<StorageService>();

  Future<void> getUsers() async {
    value = await storageService.getUsers();
    print(value);
    notifyListeners();
  }

  Future<void> insert(User u) async {
    await storageService.insertUser(u);
    await getUsers();
  }

  Future<void> deleteUser(int id) async {
    await storageService.deleteUser(id);
    await getUsers();
  }

  Future<void> modifyUserPw(int id, String str) async {
    await storageService.updatePassword(id, str);
    await getUsers();
  }
}
