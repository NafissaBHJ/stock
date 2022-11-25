import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:stock/utils/widgets/input_widget.dart';

import '../../modals/user_model.dart';
import '../../services/service_locator.dart';
import 'list_screen_manager.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final stateManager = getIt<ListManager>();
  @override
  void initState() {
    stateManager.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<User>>(
      builder: (context, value, child) {
        material.DataTableSource source = UserDataSourceTable(
            delete: ((index) => delete(context, value[index])),
            list: value,
            updatePw: (index) => modifyPw(context, value[index]),
            deleteH: ((index) => deleteH(value[index])));

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: material.Material(
            child: PaginatedDataTable2(
              header: SizedBox(
                width: 100,
                child: Button(
                    child: const Text('Ajouter utilisateur'),
                    onPressed: (() => addUser(context))),
              ),
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: const [
                DataColumn2(label: Text("Username")),
                DataColumn2(label: Text("Password")),
                DataColumn2(label: Text("Fonction")),
                DataColumn2(label: Text("Action")),
              ],
              source: source,
            ),
          ),
        );
      },
      valueListenable: stateManager.userNotifier,
    );
  }

  addUser(BuildContext context) {
    var stateManager = getIt<ListManager>();
    var _key = GlobalKey<FormState>();
    var c1 = TextEditingController();
    var c2 = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) => ValueListenableBuilder<int>(
            valueListenable: stateManager.fonctionalityNotfier,
            builder: ((context, value, child) {
              return ContentDialog(
                title: Text("Ajouter"),
                content: Form(
                  key: _key,
                  child: SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputWidget(
                          controller: c1,
                          field: "Username",
                          input: "Entrer un nom d'utilisateur",
                        ),
                        InputWidget(
                          controller: c2,
                          field: "Password",
                          input: "Entrer un mot de passe ",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RadioButton(
                                checked: value == 1,
                                content: Text("Admin"),
                                onChanged: ((val) {
                                  if (val) {
                                    stateManager.updateFunction(1);
                                  }
                                })),
                            RadioButton(
                                checked: value == 2,
                                content: Text("Utilisateur"),
                                onChanged: ((val) {
                                  if (val) {
                                    stateManager.updateFunction(2);
                                  }
                                }))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: (() {
                        if (_key.currentState!.validate() && value != 0) {
                          stateManager.insertNewUser(c1.text, c2.text, value);
                          Navigator.pop(context);
                        }
                      }),
                      child: Text('Enregistrer'))
                ],
              );
            }))));
  }

  delete(BuildContext context, User value) {
    var stateManager = getIt<ListManager>();

    return showDialog(
        context: (context),
        barrierDismissible: true,
        builder: ((context) {
          return ContentDialog(
              title: const Text("Suppression"),
              content: Text("Vous voulez vraiment supprimer ${value.username}"),
              actions: [
                TextButton(
                    onPressed: (() => stateManager.deleteUser(value.id!)),
                    child: const Text('Supprimer'))
              ]);
        }));
  }

  modifyPw(BuildContext context, User value) {
    var stateManager = getIt<ListManager>();
    var c1 = TextEditingController();
    var _key = GlobalKey<FormState>();
    return showDialog(
        context: (context),
        barrierDismissible: true,
        builder: ((context) {
          return ContentDialog(
            title: const Text("Nouveau mot de passe"),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                      key: _key,
                      child: InputWidget(
                          field: "Mot de passe", input: "", controller: c1))
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (() {
                    if (_key.currentState!.validate()) {
                      stateManager.updateUserPw(value.id!, c1.text);
                      Navigator.pop(context);
                    }
                  }),
                  child: const Text('Enregistrer'))
            ],
          );
        }));
  }

  deleteH(User u) {
      var stateManager = getIt<ListManager>();

    return showDialog(
        context: (context),
        barrierDismissible: true,
        builder: ((context) {
          return ContentDialog(
              title: const Text("Suppression"),
              content: Text("Vous voulez vraiment supprimer l'historique de ${u.username}"),
              actions: [
                TextButton(
                    onPressed: (() => stateManager.deleteUserHistory(u.username!)),
                    child: const Text('Supprimer'))
              ]);
        }));
  }
}
