import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/modals/data_model.dart';
import 'package:stock/screens/form/form_screen_manager.dart';
import 'package:stock/services/service_locator.dart';

import '../../utils/widgets/input_widget.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key, required this.insert, required this.product})
      : super(key: key);
  bool insert;
  Product? product;
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late Product? p = widget.product;

  late var controllerP =
      TextEditingController(text: p == null ? null : p!.product);
  late var controllerF =
      TextEditingController(text: p == null ? null : p!.fournisseur);
  late var controllerS =
      TextEditingController(text: p == null ? null : p!.seuil.toString());
  late var controllerE =
      TextEditingController(text: p == null ? null : p!.period.toString());
  late var controllerC1 =
      TextEditingController(text: p == null ? null : p!.quantite.toString());
  late var controllerC2 =
      TextEditingController(text: p == null ? null : p!.nbTest.toString());
  late var controllerTVA =
      TextEditingController(text: p == null ? null : p!.prixTVA.toString());
  late var controllerHT =
      TextEditingController(text: p == null ? null : p!.prixHT.toString());
  late var controllerTTC =
      TextEditingController(text: p == null ? null : p!.prixTTCu.toString());
  late var controllerRemise =
      TextEditingController(text: p == null ? null : p!.remise.toString());
  late var controllerReste =
      TextEditingController(text: p == null ? null : p!.remain.toString());
  final _key = GlobalKey<FormState>();

  final stateManager = getIt<FormManager>();

  int time1 = 1;

  int time2 = 2;
  @override
  void initState() {
    stateManager.init();
    if (p != null) {
      stateManager.ttcNotifier.value = p!.prixTTCu;
    } else {
      stateManager.ttcNotifier.value = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.all(8.0),
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputWidget(
                      field: "Produit",
                      input: "Enter produit",
                      controller: controllerP,
                    ),
                    InputWidget(
                      field: "Fournisseur",
                      input: "Enter Fournisseur",
                      controller: controllerF,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputNumberWidget(
                      field: "Prix HT",
                      input: "Entrer Prix HT",
                      controller: controllerHT,
                    ),
                    InputNumberWidget(
                      field: "TVA",
                      input: "Entrer TVA",
                      controller: controllerTVA,
                      calcule: true,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputNumberWidget(
                      field: "Remise",
                      input: "Entrer ",
                      controller: controllerRemise,
                      calcule: true,
                    ),
                    ValueListenableBuilder<int>(
                      builder: (BuildContext context, value, Widget? child) {
                        print(controllerTTC.text);
                        print("val$value");
                        controllerTTC.text = value.toString();
                        return InputNumberWidget(
                          field: "Prix TTC",
                          input: "Entrer",
                          controller: controllerTTC,
                          calcule: false,
                        );
                      },
                      valueListenable: stateManager.ttcNotifier,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputNumberWidget(
                      controller: controllerC1,
                      field: "Quantité",
                      input: 'Entrer la quantitée globale',
                    ),
                    InputNumberWidget(
                      controller: controllerC2,
                      field: "Nombre de tests",
                      input: 'Entrer le nombre de tests',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputNumberWidget(
                      field: "Seuil de notification",
                      input: "Enter seuil",
                      controller: controllerS,
                    ),
                    InputNumberWidget(
                      field: "Periode",
                      input: "Modifier la periode ",
                      controller: controllerE,
                    ),
                  ],
                ),
                p != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            InputNumberWidget(
                              field: "Quantité restante",
                              input: "Modifier ",
                              controller: controllerReste,
                            ),
                          ])
                    : SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TimePickerWidget(
                      value: "Date Achat",
                      time: time1,
                    ),
                    TimePickerWidget(
                      value: "Date Péromption",
                      time: time2,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Button(
                      child: SizedBox(
                          width: 150,
                          height: 30,
                          child: Center(
                              child: p == null
                                  ? Text("Enregistrer")
                                  : Text("Modifier"))),
                      onPressed: (() {
                        if (_key.currentState!.validate()) {
                          if (p == null) {
                            stateManager.InsertProduct(
                                controllerP.text,
                                controllerF.text,
                                controllerS.text,
                                controllerE.text,
                                controllerC1.text,
                                controllerC2.text,
                                controllerTTC.text,
                                controllerHT.text,
                                controllerTVA.text,
                                controllerRemise.text);
                            controllerC1.clear();
                            controllerC2.clear();
                            controllerF.clear();
                            controllerS.clear();
                            controllerE.clear();
                            controllerHT.clear();
                            controllerP.clear();
                            controllerTTC.clear();
                            controllerTVA.clear();
                            controllerRemise.clear();
                          } else {
                            stateManager.updateProduct(
                              p!.id!,
                              controllerP.text,
                              controllerF.text,
                              controllerHT.text,
                              controllerTVA.text,
                              controllerTTC.text,
                              controllerRemise.text,
                              controllerC1.text,
                              controllerC2.text,
                              controllerS.text,
                              controllerReste.text,
                              controllerE.text,
                            );
                          }
                        }
                      })),
                )
              ]),
        ),
      ),
    );
  }
}

class InputNumberWidget extends StatelessWidget {
  InputNumberWidget({
    required String field,
    required String input,
    required TextEditingController controller,
    bool? calcule,
    Key? key,
  })  : _field = field,
        _input = input,
        _controller = controller,
        setTTC = calcule ?? false,
        super(key: key);

  final String _field;
  final String _input;
  final TextEditingController _controller;
  bool setTTC;

  final stateManager = getIt<FormManager>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormBox(
          controller: _controller,
          header: _field,
          placeholder: _input,
          validator: (value) => stateManager.validateN(value),
          decoration: const BoxDecoration(),
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
            if (_field.compareTo("TVA") == 0) {
              stateManager.tva = int.tryParse(_controller.text);
            }
            if (_field.compareTo("Prix HT") == 0) {
              stateManager.prix = int.tryParse(_controller.text);
            }
            if (_field.compareTo("Remise") == 0) {
              if (_controller.text.isNotEmpty) {
                stateManager.remise = int.tryParse(_controller.text);
              }
            }
            if (setTTC) {
              stateManager.calculeTTC();
            }
          },
          enabled: _field.compareTo("Prix TTC") != 0 ? true : false,
        ),
      ),
    );
  }
}

class Counter extends StatelessWidget {
  Counter(
      {Key? key,
      required TextEditingController controller,
      required String title})
      : _controller = controller,
        _title = title,
        super(key: key);
  final TextEditingController _controller;
  final String _title;
  final stateManager = getIt<FormManager>();
  @override
  Widget build(BuildContext context) {
    _controller.text = "0";
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormBox(
          placeholder: "0",
          header: _title,
          controller: _controller,
          validator: (value) => stateManager.validateN(value),
          suffix: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(FluentIcons.up, size: 5),
                  onPressed: () {
                    _controller.text =
                        stateManager.incrementCounter(_controller.text);
                  }),
              IconButton(
                icon: const Icon(FluentIcons.down, size: 5),
                onPressed: () {
                  _controller.text =
                      stateManager.decrementCounter(_controller.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  TimePickerWidget({Key? key, required String value, required this.time})
      : title = value,
        super(key: key);
  final String title;
  int time;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final state = getIt<FormManager>();
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DatePicker(
          selected: time,
          header: widget.title,
          onChanged: (value) {
            setState(() {
              time = value;
            });
            if (widget.time == 1) {
              state.time1 = value;
            } else {
              state.time2 = value;
            }
          },
        ),
      ),
    );
  }
}
