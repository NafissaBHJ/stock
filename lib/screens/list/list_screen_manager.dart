import 'package:stock/screens/notifiers/product_notifier.dart';
import 'package:win_toast/win_toast.dart';

import '../../modals/data_model.dart';

class ListManager {
  final dataNotifier = ProductNotifier();

  void init() {
    dataNotifier.initialize();
  }

  void updateProduct(int id, String quantite, String tests) {
    dataNotifier.updateData(id, int.parse(quantite), int.parse(tests));
  }

  void deleteProduct(int id) {
    dataNotifier.deleteData(id);
  }

  Future<void> notification() async {
    final toast = await WinToast.instance().showToast(
        type: ToastType.text01,
        title: "Le seuil de notification est atteint !");
    assert(toast != null);
  }

  void search(String product) {
    print(product);
    if (product.isNotEmpty) {
      dataNotifier.search(product);
    }
  }

  void getData() {
    dataNotifier.getData();
  }
}
