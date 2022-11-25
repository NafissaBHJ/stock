import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:stock/modals/sort_model.dart';
import 'package:stock/screens/form/form_screen.dart';
import 'package:stock/screens/form/form_screen_manager.dart';
import 'package:stock/screens/list/list_screen_manager.dart';
import 'package:stock/services/service_locator.dart';
import 'package:stock/utils/widgets/input_widget.dart';

import '../../modals/data_model.dart';
import '../../modals/history_model.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final stateManager = getIt<ListManager>();
  late ProductDataSource source;
  bool _sortAscending = true;
  int? _sortColumnIndex;

  @override
  void initState() {
    stateManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
        valueListenable: stateManager.dataNotifier,
        builder: ((context, value, child) {
          source = ProductDataSource(
              productList: value,
              value: stateManager.dataNotifier.idNotifier.value!,
              update: (index) => modify(context, value[index]),
              delete: ((index) => delete(context, value[index])),
              history: ((index) {
                stateManager.getHistory(value[index].id!);
                history(context, value[index]);
              }),
              take: (index) => take(context, value[index]));
          return ValueListenableBuilder<Sort>(
            builder: (context, value, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: material.Material(
                    child: PaginatedDataTable2(
                        sortAscending: value.asc!,
                        sortColumnIndex: value.index,
                        header: SearchWidget(),
                        actions: [
                          SizedBox(
                            width: 100,
                            child: Button(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(FluentIcons.refresh),
                                  Text("Refresh")
                                ],
                              ),
                              onPressed: () => stateManager.getData(),
                            ),
                          ),
                          SizedBox(
                              width: 100,
                              child: Button(
                                onPressed: () => stateManager.generateExcel(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(FluentIcons.download_document),
                                    Text("Excel ")
                                  ],
                                ),
                              ))
                        ],
                        columnSpacing: 10,
                        horizontalMargin: 10,
                        minWidth: 600,
                        columns: [
                          DataColumn2(
                            label: Text('Produit'),
                          ),
                          DataColumn2(
                            label: Text('Quantité'),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Q Rest'),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Nombre test'),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Prix HT'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('TVA'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Prix U TTC'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Prix T TTC'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Remise'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Q gratuite'),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Seuil'),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Date d\'achat'),
                          ),
                          DataColumn2(
                              label: Text('Date péremption'),
                              onSort: (columnIndex, ascending) {
                                stateManager.sort(source, (d) => d.datePerom,
                                    columnIndex, ascending);
                              }),
                          DataColumn2(
                            label: Text('Action'),
                          ),
                        ],
                        source: source)),
              );
            },
            valueListenable: stateManager.sortNotifier,
          );
        }));
  }

  modify(BuildContext context, Product p) async {
    var stateManager = getIt<ListManager>();
    return await showDialog<String>(
        context: context,
        builder: ((context) {
          var c1 = TextEditingController();
          c1.text = p.quantite.toString();
          var c2 = TextEditingController();
          c2.text = p.nbTest.toString();
          return ContentDialog(
            title: const Text("Modification"),
            content: SizedBox(
              width: 1000,
              child: FormScreen(
                insert: false,
                product: p,
              ),
            ),
            actions: [
              Button(
                  child: Text('Fermer'),
                  onPressed: (() {
                    stateManager.getData();
                    Navigator.pop(context);
                  }))
            ],
          );
        }),
        barrierDismissible: true);
  }

  delete(BuildContext context, Product p) async {
    var stateManager = getIt<ListManager>();

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return ContentDialog(
            title: Text("Suppression"),
            content: Text('Vous voulez supprimer ${p.product} ?'),
            actions: [
              TextButton(
                  onPressed: (() {
                    stateManager.deleteProduct(p.id!);
                    Navigator.pop(context);
                  }),
                  child: Text('Supprimer'))
            ],
          );
        }));
  }

  take(BuildContext context, Product p) async {
    var stateManager = getIt<ListManager>();
    var c1 = TextEditingController();
    var c2 = TextEditingController();
    var c3 = TextEditingController();
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return ValueListenableBuilder<bool>(
          builder: (context, value, child) {
            return ContentDialog(
              title: const Text("Consommation"),
              content: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${p.product}  /  ${p.remain}"),
                    InputNumberWidget(
                        field: "Quantité",
                        input: "Enter la quantité à prendre",
                        controller: c3),
                    InputWidget(
                        field: "Username",
                        input: "Entrer votre nom d'utilisateur",
                        controller: c1),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormBox(
                          controller: c2,
                          header: "Mot de passe",
                          placeholder: "Entrer votre mot de passe",
                          obscureText: true,
                          validator: (value) => FormManager().validate(value),
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (() {
                      stateManager.saveHistory(p, c3.text, c1.text, c2.text);
                      Navigator.pop(context);
                    }),
                    child: const Text("Enregister"))
              ],
            );
          },
          valueListenable: stateManager.isUserNotifier,
        );
      }),
    );
  }

  history(BuildContext context, Product p) async {
    var stateManager = getIt<ListManager>();

    return await showDialog<String>(
        context: context,
        builder: ((context) {
          return ValueListenableBuilder<List<History>>(
            builder: (BuildContext context, value, Widget? child) {
              return ContentDialog(
                title: const Text("Historique"),
                content: SizedBox(
                  width: 500,
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text("Name"),
                            Text("Quantite"),
                            Text("Date")
                          ],
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: value
                                .map((e) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(e.name!),
                                        Text(e.quantite.toString()),
                                        Text(e.date!)
                                      ],
                                    ))
                                .toList()),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: const Text("Fermer"))
                ],
              );
            },
            valueListenable: stateManager.historyNotifier,
          );
        }),
        barrierDismissible: true);
  }
}

class SearchWidget extends StatelessWidget {
  SearchWidget({
    Key? key,
  }) : super(key: key);

  final controller = TextEditingController();
  final stateManager = getIt<ListManager>();

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: controller,
      placeholder: "Recherche produit",
      style: const TextStyle(fontSize: 16),
      prefix: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(FluentIcons.search),
      ),
      foregroundDecoration:
          BoxDecoration(border: Border.all(color: Colors.transparent)),
      onEditingComplete: (() {
        stateManager.search(controller.text);
        controller.clear();
      }),
    );
  }
}

class NodataWidget extends StatelessWidget {
  const NodataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logistique.png",
          width: 100,
          height: 100,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: Text(
            "Pas de données trouvées",
          ),
        )
      ],
    ));
  }
}
