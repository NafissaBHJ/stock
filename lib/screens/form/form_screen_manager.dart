import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stock/modals/data_model.dart';
import 'package:stock/modals/history_model.dart';
import 'package:stock/screens/notifiers/product_notifier.dart';
import 'package:stock/services/database_service/storage_service.dart';

import '../../services/service_locator.dart';

class FormManager {
  final couunterNotifier = ValueNotifier<int>(0);
  final timePickerNotifier = ValueNotifier<DateTime>(DateTime.now());
  final productNotofier = ProductNotifier();

  final storage = getIt<StorageService>();
  final ttcNotifier = ValueNotifier<int>(0);

  DateTime time1 = DateTime.now();
  DateTime time2 = DateTime.now();
  int v = 0;
  int? tva;
  int? prix;
  int? remise;

  Future<void> init() async {
    await productNotofier.initialize();
  }

  String incrementCounter(String val) {
    v = int.parse(val) + 1;
    return v.toString();
  }

  String decrementCounter(String val) {
    if (int.parse(val) > 0) {
      v = int.parse(val) - 1;
    } else {
      v = 0;
    }

    return v.toString();
  }

  String? validate(String? value) {
    if (value!.isEmpty) {
      return "error";
    } else {
      return null;
    }
  }

  String? validateN(String? value) {
    if (value!.isEmpty) {
      return "error";
    } else {
      if (int.tryParse(value) == null) {
        return "Entrer un chiffre";
      }
      return null;
    }
  }

  void updateDate(DateTime time) {
    timePickerNotifier.value = time;
  }

  void insertProduct(
      String product,
      String fournisseur,
      String seuil,
      String period,
      String quantite,
      String nbTest,
      String ttc,
      String ht,
      String tva,
      String remise,
      String free) {
    int ttct = 0;
    if (int.parse(free) != 0) {
      ttct = int.parse(ttc) * (int.parse(quantite) - int.parse(free));
    } else {
      ttct = int.parse(ttc) * int.parse(quantite);
    }
    Product p = Product(
        product: product,
        fournisseur: fournisseur,
        prixTTCu: int.parse(ttc),
        prixTTCt: ttct,
        prixHT: int.parse(ht),
        prixTVA: int.parse(tva),
        remise: int.parse(remise),
        dateAchat: DateFormat.yMd('fr').format(time1),
        datePerom: DateFormat.yMd('fr').format(time2),
        nbTest: int.parse(nbTest),
        quantite: int.parse(quantite),
        remain: int.parse(quantite),
        period: int.parse(period),
        fusion: 0,
        free: int.parse(free),
        seuil: int.parse(seuil));
    productNotofier.add(p);
  }

  void updateProduct(
      Product prod,
      String name,
      String fournisseur,
      String ht,
      String tva,
      String ttc,
      String remise,
      String quantite,
      String nbTest,
      String seuil,
      String rest,
      String period,
      String free) {
    // if you modify quantite of the day 
    int ttct = 0;
    int qG = 0;
    int rest2 = 0;

    rest2 = prod.remain + int.parse(quantite);
    qG = prod.quantite + int.parse(quantite);
    if (int.parse(free) != prod.free) {
      ttct = (int.parse(ttc) * (qG - int.parse(free)));
    } else {
      ttct = (int.parse(ttc) * (qG - prod.free!));
    }
    History h = History(null, prod.id, 'admin', int.parse(quantite),
        DateFormat.yMd('fr').format(DateTime.now()));
    Product p = Product(
      product: name,
      fournisseur: fournisseur,
      prixTTCu: int.parse(ttc),
      prixTTCt: ttct,
      fusion: 0,
      prixHT: int.parse(ht),
      prixTVA: int.parse(tva),
      quantite: qG,
      remain: rest2,
      nbTest: int.parse(nbTest),
      period: int.parse(period),
      seuil: int.parse(seuil),
      remise: int.parse(remise),
      free: int.parse(free),
      dateAchat: DateFormat.yMd('fr').format(time1),
      datePerom: DateFormat.yMd('fr').format(time2),
    );
    productNotofier.updateData(prod.id!, p);

    productNotofier.updateProductHistoryAdmin(h);
  }

  void calculeTTC() {
    if (tva != null) {
      int ttc = (prix! * (1 + (tva! / 100))).toInt();
      ttcNotifier.value = ttc;
      ttcNotifier.notifyListeners();
    }
    if (remise != 0) {
      int ttc = (ttcNotifier.value * (1 - (remise! / 100))).toInt();
      ttcNotifier.value = ttc;
      ttcNotifier.notifyListeners();
    }
  }
}
