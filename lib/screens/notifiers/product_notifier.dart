import 'package:fluent_ui/fluent_ui.dart';

import '../../modals/data_model.dart';
import '../../services/database_service/storage_service.dart';
import '../../services/service_locator.dart';

class ProductNotifier extends ValueNotifier<List<Product>> {
  ProductNotifier() : super([]);
  final _storageService = getIt<StorageService>();

  Future<void> initialize() async {
    await _storageService.init();
    await getData();
  }

  void add(Product product) {
    _storageService.insert(product);
  }

  Future<void> getData() async {
    final List<Product> products =
        (await _storageService.getRecord())?.cast<Product>() ?? [];
    _update(products);
  }

  _update(List<Product> prds) {
    value = prds;
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
}