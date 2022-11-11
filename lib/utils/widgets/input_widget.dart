import 'package:fluent_ui/fluent_ui.dart';

import '../../screens/form/form_screen_manager.dart';
import '../../services/service_locator.dart';

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
        ),
      ),
    );
  }
}
