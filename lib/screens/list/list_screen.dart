import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:stock/screens/list/list_screen_manager.dart';
import 'package:stock/services/service_locator.dart';

import '../../modals/data_model.dart';
import '../../utils/helpers.dart';
import '../../utils/widgets/table_widget.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final stateManager = getIt<ListManager>();
  late ProductDataSource source;

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
              update: (index) => modify(context, value[index],ListType.all),
              delete: ((index) => delete(context, value[index])),
              history: ((index) {
                stateManager.getHistory(value[index].id!);
                history(context, value[index]);
              }),
              excel: ((index) => excel(context, value[index])),
              take: (index) => take(context, value[index]));

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: material.Material(
                child: TableWidget(stateManager: stateManager, source: source,type: ListType.all,)),
          );
        }));
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
