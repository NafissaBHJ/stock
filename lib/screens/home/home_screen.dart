import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;

import 'package:stock/screens/form/form_screen.dart';
import 'package:stock/screens/home/home_screen_manager.dart';
import 'package:stock/screens/list/list_screen.dart';
import 'package:stock/services/service_locator.dart';
import '../../modals/home_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stateManager = getIt<HomeManager>();

  final loggedin = false;
  @override
  void initState() {
    // stateManager.getUser();
    stateManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Home>(
      builder: (BuildContext context, value, Widget? child) {
        // showing short Toast

        return NavigationView(
          appBar: NavigationAppBar(
              title: const Text("Gestion du stock"),
              actions: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 100,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [Icon(FluentIcons.settings)],
                  ),
                ),
              ),
              automaticallyImplyLeading: false),
          contentShape: const BeveledRectangleBorder(),
          pane: stateManager.homeNotifier.value.state == true
              ? NavigationPane(
                  header: const Text("Menu"),
                  size: const NavigationPaneSize(openWidth: 200),
                  indicator: const StickyNavigationIndicator(
                    color: Colors.transparent,
                  ),
                  displayMode: PaneDisplayMode.compact,
                  selected: value.index,
                  onChanged: ((val) {
                    stateManager.updateIndex(val);
                  }),
                  items: [
                    PaneItem(
                        icon: const Icon(
                          FluentIcons.clipboard_list,
                          size: 18,
                        ),
                        title: const Text("Stock list"),
                        body: ListScreen()),
                    PaneItem(
                        icon: const Icon(
                          FluentIcons.add_to_shopping_list,
                          size: 18,
                        ),
                        title: const Text("Form"),
                        body: FormScreen())
                  ],
                )
              : null,
          content: stateManager.homeNotifier.value.state == false
              ? LoginWidget()
              : null,
        );
      },
      valueListenable: stateManager.homeNotifier,
    );
  }
}

class LoginWidget extends StatelessWidget {
  LoginWidget({
    Key? key,
  }) : super(key: key);
  final controllerU = TextEditingController();
  final controllerP = TextEditingController();
  final stateManager = getIt<HomeManager>();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      builder: (BuildContext context, value, Widget? child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 300,
          child: Acrylic(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.center,
                width: 500,
                height: MediaQuery.of(context).size.height - 400,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 32),
                      ),
                      TextFormBox(
                        controller: controllerU,
                        header: "Nom d'utilisateur",
                        placeholder: "Entrer votre nom d'utilisateur",
                        autofocus: true,
                        validator: (value) => stateManager.validate(value),
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      TextFormBox(
                          controller: controllerP,
                          header: "Mot de passe",
                          placeholder: "Entrer votre mot de passe",
                          obscureText: true,
                          validator: (value) => stateManager.validate(value),
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          }),
                      value == true
                          ? Button(
                              child: const Text("S'authentifier"),
                              onPressed: (() {
                                if (_key.currentState!.validate()) {
                                  stateManager.getUser(
                                      controllerU.text, controllerP.text);
                                }
                                controllerP.clear();
                                controllerU.clear();
                              }))
                          : const ProgressRing(),
                    ],
                  ),
                ),
              ),
            ),
            tint: Colors.transparent,
            tintAlpha: 0.2,
            luminosityAlpha: 0.2,
            blurAmount: 50,
            elevation: 10,
          ),
        );
      },
      valueListenable: stateManager.loggedNotifier,
    );
  }
}
