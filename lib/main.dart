import 'package:fluent_ui/fluent_ui.dart';
import 'package:stock/utils/custom_theme.dart';
import 'screens/home/home_screen.dart';
import 'services/service_locator.dart';
import 'package:system_theme/system_theme.dart';

Future<void> main() async {
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: "Stock",
      theme: SystemTheme.isDarkMode
          ? CustomDarkTheme(context)
          : CustomLightTheme(context),
      routes: {"/": ((context) => MyHomePage())},
      
    );
  }
}
