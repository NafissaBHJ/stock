import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/modals/history_model.dart';

import '../../modals/data_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class ProductNotifier extends ValueNotifier<List<Product>> {
  ProductNotifier() : super([]);
  final _storageService = getIt<StorageService>();
  final idNotifier = ValueNotifier<int?>(0);

  Future<void> initialize() async {
    await _storageService.init();
    await updateId();
    await getData();
  }

  void add(Product product) {
    _storageService.insert(product);
  }

  Future<void> updateId() async {
    idNotifier.value = await _storageService.getUserP();
  }

  Future<void> getData() async {
    final List<Product> products =
        (await _storageService.getRecord())?.cast<Product>() ?? [];
    print("heeeeeeeeere");
    _update(products);
  }

  _update(List<Product> prds) {
    value = prds;
    notifyListeners();
  }

  Future<void> updateData(int id, int quantite, int tests) async {
    await _storageService.update(id, quantite, tests);
    getData();
  }

  Future<void> deleteData(int id) async {
    await _storageService.delete(id);
    getData();
  }

  void search(String p) {
    Product? result = value.cast<Product?>().firstWhere(
          (element) => element!.product.compareTo(p) == 0,
          orElse: () => null,
        );
    if (result != null) {
      value = [result];
      notifyListeners();
    } else {
      value = [];
      notifyListeners();
    }
  }

  Future<void> updateProductHistory(History h, int id, int pq) async {
    await _storageService.updateHistory(h, id, pq);
    getData();
  }

  Future<List<History>?> getHistory(int id) async {
    List<History>? l = await _storageService.getHistory(id);
    return l;
  }
}
