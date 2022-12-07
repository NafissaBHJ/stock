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
    _update(products);
  }

  _update(List<Product> prds) {
    value = prds;
    notifyListeners();
  }

  Future<void> updateData(int id, Product p) async {
    await _storageService.update(id, p);
    //  / getData();
  }

  Future<void> deleteData(int id) async {
    await _storageService.delete(id);
    getData();
  }

  Future<void> search(String p) async {
    List<Product>? result = [];
    // value.forEach((element) {
    //   if (element.product.toLowerCase().contains(p.toLowerCase())) {
    //     result.add(element);
    //   }
    // });
    result = await searchProduct(p);
    if (result != null) {
      value = result;
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

  Future<void> updateProductHistoryAdmin(History h) async {
    await _storageService.updateHistoryEntry(h);
    getData();
  }

  Future<List<History>?> getHistory(int id) async {
    List<History>? l = await _storageService.getHistory(id);

    return l;
  }

  Future<List<History>?> getHistoryByProduct(int id) async {
    List<History>? l =
        (await _storageService.getHistoryByProduct(id))?.cast<History>() ?? [];

    return l;
  }

  Future<List?> getRecordsByUser(String user) async {
    List? l = (await _storageService.getRecordByUser(user))?.toList() ?? [];

    print(l);
    return l;
  }

  Future<List<Product>?> searchProduct(String str) async {
    List<Product>? l =
        (await _storageService.searchProduct(str))?.cast<Product>() ?? [];
    return l;
  }

  Future<void> deleteRecordHistory(int id) async {
    await _storageService.deleteRecordHistory(id);
  }
}
