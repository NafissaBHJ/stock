import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/modals/home_model.dart';
import 'package:win_toast/win_toast.dart';

import '../../modals/user_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class HomeManager {
  final homeNotifier = ValueNotifier<Home>(Home(index: 0, state: false));
  final loggedNotifier = ValueNotifier<bool>(true);
  final storageService = getIt<StorageService>();
  int? u;

  void updateIndex(int v) {
    homeNotifier.value.index = v;
    homeNotifier.notifyListeners();
  }

  Future<void> init() async {
    await storageService.init();
    // initialize toast with you app, product, company names.
    await WinToast.instance().initialize(
        appName: 'stock', productName: 'stockApp', companyName: 'nafissaLab');
  }

  Future<void> getUser(String username, String password) async {
    updateLoginNotifier(false);

    User? user = await storageService.getAdmin(username, password);
    if (user != null) {
  
      await storageService.setUser(user.id!);
   
      updateStateNotifier(true);
    } else {
      updateLoginNotifier(true);
    }
  }

  void updateStateNotifier(bool val) {
    homeNotifier.value.state = val;
    homeNotifier.notifyListeners();
      loggedNotifier.value =!val;
    loggedNotifier.notifyListeners;
  }

  void updateLoginNotifier(bool val) {
    print(val);
    loggedNotifier.value = val;
    loggedNotifier.notifyListeners;
  }

  String? validate(String? input) {
    if (input!.isEmpty) {
      return "Entrer une valeur";
    } else {
      if (input.length < 4) {
        return "input too short";
      } else {
        return null;
      }
    }
  }
}
