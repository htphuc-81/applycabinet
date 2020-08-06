import 'package:get_it/get_it.dart';
import 'services/db_manager.dart';
import 'services/share_prefs.dart';
import 'services/user_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserManager());
  locator.registerLazySingleton(() => SharePrefs());
  locator.registerLazySingleton(() => DBManager());
}