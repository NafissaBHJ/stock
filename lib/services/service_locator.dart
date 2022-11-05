import 'package:get_it/get_it.dart';
import 'package:stock/screens/home/home_screen_manager.dart';

import '../screens/form/form_screen_manager.dart';
import '../screens/list/list_screen_manager.dart';
import 'database_service/database_service_storage.dart';
import 'database_service/storage_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<HomeManager>(() => HomeManager());
  getIt.registerLazySingleton<ListManager>(() => ListManager());
  getIt.registerLazySingleton<FormManager>(() => FormManager());
  getIt.registerLazySingleton<StorageService>(() => DatabaseServiceStorage());
}
