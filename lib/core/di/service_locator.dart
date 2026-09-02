import 'package:get_it/get_it.dart';
import '../../configs/app_urls.dart';
import '../database/tables/database.dart';
import '../sync/sync_engine.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  final baseUrl = AppUrls.baseUrl.endsWith('/')
      ? AppUrls.baseUrl.substring(0, AppUrls.baseUrl.length - 1)
      : AppUrls.baseUrl;

  final syncEngine = SyncEngine(db, baseUrl: baseUrl);
  getIt.registerSingleton<SyncEngine>(syncEngine);
}