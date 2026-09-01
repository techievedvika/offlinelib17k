import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../tables/students_table.dart';
import '../tables/book_table.dart';
import '../tables/book_issue_table.dart';
import '../tables/activity_logs_table.dart';
import '../tables/reference_tables.dart';
import '../tables/sync_tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Students, Books, BookIssues, ActivityLogs,
  Grades, SchoolBasicCache, GeneralLinksCache,
  SyncOutbox, PendingUploads, SyncMeta,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'lib17000ft.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}