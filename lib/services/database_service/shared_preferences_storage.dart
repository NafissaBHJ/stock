import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/database_service/storage_service.dart';

class SharedPreferenceStorage extends StorageService {
  @override
  Future<void> setUser(int state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("user_id", state);
  }

  @override
  Future<int?> getUserP() async {
    late int id;
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("user_id")!;
    print("eeeeeeeeeeeeeeeeeeee$id");
    return id;
  }
}
