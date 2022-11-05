import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/modals/history_model.dart';
import 'package:stock/screens/form/form_screen_manager.dart';
import 'package:stock/services/service_locator.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var controllerP = TextEditingController();

  var controllerF = TextEditingController();
  var controllerS = TextEditingController();

  var controllerE = TextEditingController();

  var controllerC1 = TextEditingController();

  var controllerC2 = TextEditingController();

  var controllerTVA = TextEditingController();

  var controllerHT = TextEditingController();

  var controllerTTC = TextEditingController();

  var controllerRemise = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();

  final _key = GlobalKey<FormState>();

  final stateManager = getIt<FormManager>();

  int time1 = 1;

  int time2 = 2;
  @override
  void initState() {
    stateManager.init();
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
                    ),
                    ValueListenableBuilder<int>(
                      builder: (BuildContext context, value, Widget? child) {
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
                    Counter(
                      controller: controllerC1,
                      title: "Quantité",
                    ),
                    Counter(
                      controller: controllerC2,
                      title: "Nombre de tests",
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
                      input:
                          "Enter la periode en jours pour notifier avant péromption",
                      controller: controllerE,
                    ),
                  ],
                ),
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
                          child: Center(child: const Text("Enregistrer"))),
                      onPressed: (() {
                        if (_key.currentState!.validate()) {
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
                        }
                      })),
                )
              ]),
        ),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  InputWidget({
    required String field,
    required String input,
    required TextEditingController controller,
    Key? key,
  })  : _field = field,
        _input = input,
        _controller = controller,
        super(key: key);

  final String _field;
  final String _input;
  final TextEditingController _controller;

  final stateManager = getIt<FormManager>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: stateManager.userNotifer,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormBox(
              controller: _controller,
              header: _field,
              placeholder: _input,
              validator: (value) => stateManager.validate(value),
              decoration: const BoxDecoration(),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              enabled: value == 1 ? true : false,
            ),
          ),
        );
      },
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
    return ValueListenableBuilder<int?>(
      builder: (BuildContext context, value, Widget? child) {
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
                if (setTTC) {
                  stateManager.calculeTTC();
                }
              },
              enabled: value == 1 && (_field.compareTo("Prix TTC") != 0)
                  ? true
                  : false,
            ),
          ),
        );
      },
      valueListenable: stateManager.userNotifer,
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
