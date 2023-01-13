import 'package:fluent_ui/fluent_ui.dart';
import 'package:win_toast/win_toast.dart';

import '../modals/data_model.dart';
import '../modals/history_model.dart';
import '../screens/form/form_screen.dart';
import '../screens/form/form_screen_manager.dart';
import '../screens/list/list_screen_manager.dart';
import '../services/service_locator.dart';
import 'widgets/input_widget.dart';

// ** Dialog helpers for  update and deletion operations

modify(BuildContext context, Product p, ListType type) async {
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
                child: const Text('Fermer'),
                onPressed: (() {
                  if (type == ListType.all) {
                    stateManager.getData();
                  }

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
                          Text("Date"),
                          Text("Action"),
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
                                      Text(e.id.toString()!),
                                      Text(e.name!),
                                      Text(e.quantite.toString()),
                                      Text(e.date!),
                                      TextButton(
                                          child: const Text("Supprimer"),
                                          onPressed: () {
                                            stateManager
                                                .deleteHistoryRecord(e.id!);
                                            Navigator.pop(context);
                                          })
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

excel(BuildContext context, Product p) async {
  var stateManager = getIt<ListManager>();

  stateManager.generateExcel(ListType.daily, p);
}

Future<void> notification(String title) async {
  final toast =
      await WinToast.instance().showToast(type: ToastType.text01, title: title);
  assert(toast != null);
}

Future<void> notificationDate(String name) async {
  final toast = await WinToast.instance().showToast(
      type: ToastType.text01,
      title: "La Date de Péremption pour le produit $name est Proche !");
  assert(toast != null);
}
