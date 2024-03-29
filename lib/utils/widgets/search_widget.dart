import 'package:fluent_ui/fluent_ui.dart';

import '../../screens/list/list_screen_manager.dart';
import '../../services/service_locator.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({Key? key, required this.type}) : super(key: key);

  final controller = TextEditingController();

  final controller2 = TextEditingController();
  final stateManager = getIt<ListManager>();
  final ListType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 30,
          width: 300,
          child: TextBox(
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
              stateManager.search(controller.text, type);
              controller.clear();
            }),
          ),
        ),
        SizedBox(
          height: 30,
          width: 300,
          child: TextBox(
            controller: controller2,
            placeholder: "JJ/MM/YYYY",
            style: const TextStyle(fontSize: 16),
            prefix: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FluentIcons.search),
            ),
            foregroundDecoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            onEditingComplete: (() {
              stateManager.searchByDate(controller2.text);
              controller.clear();
            }),
          ),
        ),
      ],
    );
  }
}
