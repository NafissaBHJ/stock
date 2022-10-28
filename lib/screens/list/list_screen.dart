import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:stock/screens/list/list_screen_manager.dart';
import 'package:stock/services/service_locator.dart';

import '../../modals/data_model.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final stateManager = getIt<ListManager>();

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
          material.DataTableSource source = ProductDataSource(
              productList: value,
              update: (index) => modify(context, value[index]),
              delete: ((index) => delete(context, value[index])));
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: material.Material(
              child: value.isNotEmpty
                  ? PaginatedDataTable2(
                      header: SearchWidget(),
                      actions: [
                        IconButton(
                          icon: const Icon(FluentIcons.refresh),
                          onPressed: () => stateManager.getData(),
                        )
                      ],
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(
                          label: Text('Produit'),
                        ),
                        DataColumn2(
                            label: Text('Fournisseur'), size: ColumnSize.M),
                        DataColumn2(
                          label: Text('Quantité'),
                          size: ColumnSize.S,
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Numbre test'),
                          size: ColumnSize.S,
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Prix HT'),
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Prix TVA'),
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Prix TTC'),
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Remise'),
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Seuil'),
                          size: ColumnSize.S,
                          numeric: true,
                        ),
                        DataColumn2(
                          label: Text('Admin'),
                        ),
                        DataColumn2(
                          label: Text('Date d\'achat'),
                        ),
                        DataColumn2(
                          label: Text('Date péremption'),
                        ),
                        DataColumn2(
                          label: Text('Action'),
                        ),
                      ],
                      source: source)
                  : const NodataWidget(),
            ),
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
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${p.product}  /  ${p.fournisseur}"),
                  TextBox(
                    header: "Quantité",
                    controller: c1,
                  ),
                  TextBox(
                    header: "Nombre de test",
                    controller: c2,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (() {
                    stateManager.updateProduct(p.id!, c1.text, c2.text);
                    Navigator.pop(context);
                  }),
                  child: const Text("Modifier"))
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
                  onPressed: (() => stateManager.deleteProduct(p.id!)),
                  child: Text('Supprimer'))
            ],
          );
        }));
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
