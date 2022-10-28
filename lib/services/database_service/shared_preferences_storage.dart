import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/database_service/storage_service.dart';

import '../../modals/user_model.dart';

class SharedPreferenceStorage extends StorageService {
  @override
  Future<void> setUser(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("logged_in", state);
  }

  @override
  Future<bool> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }
}
