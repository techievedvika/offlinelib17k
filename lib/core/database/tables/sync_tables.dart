import 'package:drift/drift.dart';

class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // 'student' | 'book' | 'issue' | 'activity_log'
  TextColumn get entityKey => text()();  // rollno / isbn / uniqid-status / localId
  TextColumn get operation => text()();  // 'create' | 'update' — never 'delete'
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

class PendingUploads extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // 'book' | 'activity_log'
  TextColumn get entityKey => text()();  // isbn or localId
  TextColumn get fieldName => text()();  // 'cover_page' or 'photo'
  TextColumn get localFilePath => text()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
}

class SyncMeta extends Table {
  TextColumn get key => text()();   // 'last_synced_students', 'last_synced_books', etc.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}