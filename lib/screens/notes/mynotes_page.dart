import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:stock/screens/notes/mynotes_page_logic.dart';
import 'package:stock/screens/notifiers/data_notifier.dart';
import 'package:stock/services/database_service/storage_service.dart';
import 'package:stock/services/service_locator.dart';

import '../../modals/note_model.dart';

class MyNotesPage extends StatefulWidget {
  MyNotesPage({Key? key}) : super(key: key);

  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  final stateManager = getIt<MyNotesPageManager>();
  // final DataTableSource dt = DessertDataSource();
  @override
  void initState() {
    stateManager.initDataState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<MyNotesPageManager>();
    return ValueListenableBuilder<List<Note>?>(
        valueListenable: stateManager.dataNotifier,
        builder: (context, List<Note>? notes, child) {
          return Row(
            children: [
              // TextButton(
              //     child: const Text('ADD'),
              //     onPressed: () {
              //       final stateManager = getIt<MyNotesPageManager>();
              //       Note note = Note(
              //           title: "this is a note",
              //           body: "ok this is a text in the note",
              //           createdAt: DateTime.now(),
              //           updatedAt: DateTime.now());
              //       // update list view use below;
              //       //stateManager.dataNotifier.value = [...notes!]..add(note);
              //       stateManager.adding();
              //     }),
              Container(
                width: MediaQuery.of(context).size.width - 400,
                height: 500.0,
               
                child: Text('f'),
                // child: Material(
                //   child: PaginatedDataTable2(
                //       columnSpacing: 12,
                //       horizontalMargin: 12,
                //       minWidth: 600,
                //       columns: const [
                //         DataColumn2(
                //           label: Text('Column A'),
                //           size: ColumnSize.L,
                //         ),
                //         DataColumn2(
                //           label: Text('Column B'),
                //         ),
                //         DataColumn2(
                //           label: Text('Column NUMBERS'),
                //           numeric: true,
                //         ),
                //       ],
                //       source: dt),
                // ),
              ),
              // ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     itemCount: notes?.length ?? 0,
              //     itemBuilder: (context, index) {
              //       return Text(notes?[index].title ?? "No data yet");
              //     }),
              // ),
            ],
          );
        });
  }
}
