import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:stock/modals/history_model.dart';
import 'package:stock/modals/user_model.dart';
import 'package:stock/screens/notifiers/product_notifier.dart';
import 'package:stock/screens/notifiers/user_notifier.dart';
import '../../modals/data_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ListManager {
  final dataNotifier = ProductNotifier();
  final historyNotifier = ValueNotifier<List<History>>([]);
  final fonctionalityNotfier = ValueNotifier<int>(0);
  final userNotifier = UserNotifier();
  final isUserNotifier = ValueNotifier<bool>(true);

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

  Future<void> saveHistory(
      Product p, String quantite, String name, String password) async {
    isUserNotifier.value = await userNotifier.verifyUser(name, password);
    print(isUserNotifier.value);
    isUserNotifier.notifyListeners();

    if (isUserNotifier.value == true) {
      int remain = p.remain - int.parse(quantite);
      History history = History(p.id, name, int.parse(quantite),
          DateFormat.yMd('fr').format(DateTime.now()));
      dataNotifier.updateProductHistory(history, p.id!, remain);
      isUserNotifier.value = true;
    }
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

  Future<void> generateExcel() async {
    final Workbook workbook = Workbook();
    int i = 1;
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A' + i.toString()).setText("Produit");
    sheet.getRangeByName('B' + i.toString()).setText("Fournisseur");
    sheet.getRangeByName('C' + i.toString()).setText("Quantité");
    sheet.getRangeByName('D' + i.toString()).setText("Reste");
    sheet.getRangeByName('E' + i.toString()).setText("Prix unitaire");
    sheet.getRangeByName('F' + i.toString()).setText("Prix Total");
    sheet.getRangeByName('G' + i.toString()).setText("TVA");
    sheet.getRangeByName('H' + i.toString()).setText("Remise");
    sheet.getRangeByName('I' + i.toString()).setText("nombre Test");
    sheet.getRangeByName('J' + i.toString()).setText("Date d'achat");
    sheet.getRangeByName('K' + i.toString()).setText("Date péromption");

    i = 2;
    dataNotifier.value.forEach((element) {
      sheet.getRangeByName('A' + i.toString()).setText(element.product);
      sheet.getRangeByName('B' + i.toString()).setText(element.fournisseur);
      sheet
          .getRangeByName('C' + i.toString())
          .setText(element.quantite.toString());
      sheet
          .getRangeByName('D' + i.toString())
          .setText(element.remain.toString());
      sheet
          .getRangeByName('E' + i.toString())
          .setText(element.prixTTCu.toString());
      sheet
          .getRangeByName('F' + i.toString())
          .setText(element.prixTTCt.toString());
      sheet
          .getRangeByName('G' + i.toString())
          .setText(element.prixTVA.toString());
      sheet
          .getRangeByName('H' + i.toString())
          .setText(element.remise.toString());
      sheet
          .getRangeByName('I' + i.toString())
          .setText(element.nbTest.toString());
      sheet.getRangeByName('J' + i.toString()).setText(element.dateAchat);
      sheet.getRangeByName('K' + i.toString()).setText(element.datePerom);

      i++;
    });

    var databasesPath = await getApplicationDocumentsDirectory();
    // var path = p.join(Directory.current.path, 'assets/db.sqlite');
    var path = p.join(databasesPath.path, 'ImportDataList.xlsx');

    final List<int> bytes = workbook.saveAsStream();
    File(path).writeAsBytes(bytes);
    workbook.dispose();
  }
}
