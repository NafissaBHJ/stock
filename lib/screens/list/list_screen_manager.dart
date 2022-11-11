import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:stock/modals/history_model.dart';
import 'package:stock/modals/user_model.dart';
import 'package:stock/screens/notifiers/product_notifier.dart';
import 'package:stock/screens/notifiers/user_notifier.dart';
import '../../modals/data_model.dart';

class ListManager {
  final dataNotifier = ProductNotifier();
  final historyNotifier = ValueNotifier<List<History>>([]);
  final fonctionalityNotfier = ValueNotifier<int>(0);
  final userNotifier = UserNotifier();

  Future<void> init() async {
    dataNotifier.initialize();
  }

  Future<void> getUsers() async {
    await userNotifier.getUsers();
  }

  void deleteProduct(int id) {
    dataNotifier.deleteData(id);
  }

  void search(String product) {
    if (product.isNotEmpty) {
      dataNotifier.search(product);
    }
  }

  void getData() {
    dataNotifier.getData();
  }

  void saveHistory(Product p, String quantite, String name) {
    int remain = p.remain - int.parse(quantite);
    History history = History(p.id, name, int.parse(quantite),
        DateFormat.yMd('fr').format(DateTime.now()));
    dataNotifier.updateProductHistory(history, p.id!, remain);
  }

  Future<void> getHistory(int id) async {
    var list = await dataNotifier.getHistory(id);
    historyNotifier.value = list ?? [];
    historyNotifier.notifyListeners();
  }

  Future<void> insertNewUser(
      String username, String password, int jobId) async {
    User u = User(username: username, password: password, jobId: jobId);
    await userNotifier.insert(u);
  }

  Future<void> updateUserPw(int id, String password) async {
    print(password);
    await userNotifier.modifyUserPw(id, password);
  }

  Future<void> deleteUser(int id) async {
    await userNotifier.deleteUser(id);
  }

  void updateFunction(dynamic v) {
    fonctionalityNotfier.value = v;
    fonctionalityNotfier.notifyListeners();
  }
}
