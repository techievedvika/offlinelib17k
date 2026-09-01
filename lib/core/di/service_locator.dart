import 'package:get_it/get_it.dart';
import '../database/tables/database.dart';
import '../sync/sync_engine.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  final syncEngine = SyncEngine(db, baseUrl: 'https://library.17000ft.org/api/library');
  getIt.registerSingleton<SyncEngine>(syncEngine);
}