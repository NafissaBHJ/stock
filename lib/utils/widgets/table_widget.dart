import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/utils/widgets/search_widget.dart';

import '../../modals/data_model.dart';
import '../../screens/list/list_screen_manager.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    Key? key,
    required this.stateManager,
    required this.source,
    required this.type
  }) : super(key: key);

  final ListManager stateManager;
  final ProductDataSource source;
  final ListType type;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
        header: SearchWidget(type: type,),
        actions: [
          SizedBox(
            width: 100,
            child: Button(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [Icon(FluentIcons.refresh), Text("Refresh")],
              ),
              onPressed: () => stateManager.getData() ,
            ),
          ),
          SizedBox(
              width: 100,
              child: Button(
                onPressed: () => stateManager.generateExcel(type,null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                stateManager.sort(
                    source, (d) => d.datePerom, columnIndex, ascending);
              }),
          DataColumn2(
            label: Text('Action'),
          ),
        ],
        source: source);
  }
}
