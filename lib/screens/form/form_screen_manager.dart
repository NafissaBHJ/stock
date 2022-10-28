import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stock/modals/data_model.dart';
import 'package:stock/screens/notifiers/product_notifier.dart';

class FormManager {
  final couunterNotifier = ValueNotifier<int>(0);
  final timePickerNotifier = ValueNotifier<DateTime>(DateTime.now());
  final productNotofier = ProductNotifier();
  DateTime time1 = DateTime.now();
  DateTime time2 = DateTime.now();
  int v = 0;

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
    print(value);
    if (value!.isEmpty) {
      return "error";
    } else {
      return null;
    }
  }

  String? validateN(String? value) {
    print(value);
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
    print(time);
    timePickerNotifier.value = time;
  }

  void InsertProduct(String product, String fournisseur, String seuil,String employe,String quantite,
      String nbTest, String ttc, String ht, String tva, String remise) {
    Product p = Product(
        product: product,
        fournisseur: fournisseur,
        prixTTC: int.parse(ttc),
        prixHT: int.parse(ht),
        prixTVA: int.parse(tva),
        remise: int.parse(remise),
        dateAchat: DateFormat.yMd('fr').format(time1),
        datePerom: DateFormat.yMd('fr').format(time2),
        nbTest: int.parse(nbTest),
        quantite: int.parse(quantite), employe: employe, seuil: int.parse(seuil));
    productNotofier.add(p);
  }
}
