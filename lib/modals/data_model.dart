import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../services/database_service/storage_service.dart';
import '../services/service_locator.dart';

class Product {
  int? id;
  String product;
  String fournisseur;
  String? employe;
  int seuil;
  int prixTTCu;
  int prixTTCt;
  int fusion;
  int prixHT;
  int prixTVA;
  int? remise;
  int quantite;
  int remain;
  int? free;
  int nbTest;
  bool? rest;
  bool? perom;
  int period;
  String dateAchat;
  String datePerom;
  String? updatedAt;

  Product(
      {this.id,
      required this.product,
      required this.fournisseur,
      required this.prixTTCu,
      required this.prixTTCt,
      required this.fusion,
      required this.prixHT,
      required this.prixTVA,
      this.remise,
      required this.quantite,
      required this.remain,
      this.free,
      required this.nbTest,
      required this.period,
      required this.seuil,
      required this.dateAchat,
      required this.datePerom,
      this.updatedAt});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "produit": product,
      "fournisseur": fournisseur,
      "quantite": quantite,
      "rest": remain,
      "qfree": free ?? 0,
      "nb_test": nbTest,
      "ht": prixHT,
      "tva": prixTVA,
      "remise": remise ?? 0,
      "ttcu": prixTTCu,
      "ttct": prixTTCt,
      "fusion": fusion,
      "user": employe ?? "Admin",
      "period": period,
      "seuil": seuil,
      "date_achat": dateAchat,
      "date_peromp": datePerom,
      "updated_at": updatedAt ?? "",
    };

    return map;
  }

  factory Product.fromMap(dynamic map) {
    return Product(
      id: map['id'],
      product: map['produit'] as String,
      fournisseur: map['fournisseur'],
      dateAchat: map['date_achat'],
      datePerom: map['date_peromp'],
      nbTest: map['nb_test'],
      prixHT: map['ht'],
      prixTTCu: map['ttcu'],
      prixTTCt: map['ttct'],
      fusion: map['fusion'],
      prixTVA: map['tva'],
      quantite: map['quantite'],
      remain: map['rest'],
      remise: map['remise'] ?? 0,
      period: map['period'] ?? 0,
      free: map['qfree'] ?? 0,
      seuil: map['seuil'],
      updatedAt: map['updated_at'],
    );
  }

  String refactorHT() {
    return prixHT.toDouble().toString();
  }

  String refactorTTCt() {
    return prixTTCt.toDouble().toString();
  }

  String refactorTTCu() {
    return prixTTCu.toDouble().toString();
  }

  String refactorTVA() {
    return prixTVA.toString() + " %";
  }

  String refactorRemise() {
    return remise!.toString() + " %";
  }

  String getfree() {
    if (free == null) {
      return "0";
    } else {
      return free.toString();
    }
  }

  bool calculeRest() {
    rest = remain + (free ?? 0) > seuil ? false : true;
    // if (rest == true) {
    //   notification(product);
    // }
    return rest!;
  }

  DateTime stringToDateP() {
    return DateFormat('d/MM/y').parse(datePerom);
  }

  DateTime stringToDateA() {
    return DateFormat('d/MM/y').parse(dateAchat);
  }

  bool verificationDate() {
    perom = false;
    var dateTime1 = DateTime.now();
    var dateTime2 =
        DateFormat('d/MM/y').parse(datePerom).subtract(Duration(days: period));

    if ((dateTime1.day == dateTime2.day) &&
        (dateTime1.month == dateTime2.month) &&
        (dateTime1.year == dateTime2.year)) {
      perom = true;
    } else {
      perom = false;
    }
    // if (perom == true) {
    //   notificationDate(product);
    // }
    return perom!;
  }

  /*
   *
   *  Notifications for windows 
   * 
  */

}

/*
*
* The below class is for the product ( main data ) database operations
*
*/
class ProductProvider {
  late var db;
  late String _path;
  late DatabaseFactory databaseFactorys;

  Future<void> createDb(String path) async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
  }

  Future<void> insertProduct(Product p, String path) async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = p.toMap();
    db.insert("product", value);
    await db.close();
  }

  Future<List<Product>> getAllProducts(String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var products =
        await db.rawQuery('SELECT * from product ORDER BY produit ASC');
    await db.close();
    return List<Product>.from(products.map((e) => Product.fromMap(e)).toList());
  }

  Future<List<Product>> getProductsByDate(String date, String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var products =
        await db.rawQuery('SELECT * from product where updated_at=?', [date]);
    await db.close();
    return List<Product>.from(products.map((e) => Product.fromMap(e)).toList());
  }

  Future<List<Product>?> search(String str, String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var products = await db
        .rawQuery('''SELECT * from product WHERE produit LIKE '%$str%' ''');
    await db.close();
    return List<Product>.from(products.map((e) => Product.fromMap(e)).toList());
  }

  Future<List<Product>?> searchProductByDate(String str, String path) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var products = await db
        .rawQuery('''SELECT * from product WHERE date_achat LIKE '%$str%' ''');
    await db.close();
    return List<Product>.from(products.map((e) => Product.fromMap(e)).toList());
  }

  Future<void> updateProduct(String path, int id, Product p) async {
    databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(path);
    var value = p.toMap();
    await db.update("product", value, where: 'id = ?', whereArgs: [id]);
    await db.close();
  }

  Future<int> deleteProduct(int id, String path) async {
    databaseFactory = databaseFactoryFfi;

    db = await databaseFactory.openDatabase(path);
    return await db.delete("product", where: 'id = ?', whereArgs: [id]);
  }
}

/*
 * 
 *  Below class to return the product's rows for the Datatable widget 
 * 
 */
typedef OnRowSelect = void Function(int index);

class ProductDataSource extends m.DataTableSource {
  ProductDataSource(
      {required List<Product> productList,
      required this.update,
      required this.delete,
      required this.take,
      required this.history,
      required this.excel,
      required this.value})
      : list = productList;

  List<Product> list;
  final OnRowSelect update;
  final OnRowSelect delete;
  final OnRowSelect take;
  final OnRowSelect history;
  final OnRowSelect excel;
  final int value;
  final storage = getIt<StorageService>();

  @override
  m.DataRow? getRow(int index) {
    final row = list[index];

    return RowMethod(row, index);
  }

  DataRow2 RowMethod(Product row, int index) {
    return DataRow2(
        color: row.calculeRest() == true || row.verificationDate()
            ? m.MaterialStateProperty.all<Color>(Colors.red.lightest)
            : null,
        specificRowHeight: 120,
        cells: [
          m.DataCell(Text(row.product)),
          m.DataCell(Text((row.quantite).toString())),
          m.DataCell(Text((row.remain).toString())),
          m.DataCell(Text(row.nbTest.toString())),
          m.DataCell(Text(row.refactorHT())),
          m.DataCell(Text(row.refactorTVA())),
          m.DataCell(Text(row.refactorTTCu())),
          m.DataCell(Text(row.refactorTTCt())),
          m.DataCell(Text(row.refactorRemise())),
          m.DataCell(Text(row.getfree())),
          m.DataCell(Text(
            row.seuil.toString(),
          )),
          m.DataCell(Text(row.dateAchat)),
          m.DataCell(Text(row.datePerom)),
          m.DataCell(Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: value == 1
                ? [
                    Button(
                      child: const Text(
                        "Modifier",
                      ),
                      onPressed: () => update(index),
                    ),
                    Button(
                      child: const Text(
                        "Historique",
                      ),
                      onPressed: () => history(index),
                    ),
                    Button(
                      child: const Text(
                        "  Excel   ",
                      ),
                      onPressed: () => excel(index),
                    ),
                    Button(
                      child: const Text("Supprimer"),
                      onPressed: () => delete(index),
                    )
                  ]
                : [
                    Button(
                      child: const Text(
                        "Consommer",
                      ),
                      onPressed: () => take(index),
                    ),
                  ],
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}
