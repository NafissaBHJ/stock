import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:stock/modals/history_model.dart';
import 'package:stock/screens/notifiers/product_notifier.dart';
import '../../modals/data_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class ListManager {
  final dataNotifier = ProductNotifier();
  final historyNotifier = ValueNotifier<List<History>>([]);

  Future<void> init() async {
    dataNotifier.initialize();
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
}
