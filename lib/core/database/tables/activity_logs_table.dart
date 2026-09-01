import 'package:drift/drift.dart';

class ActivityLogs extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get localId => text()(); // client-generated, no natural key exists for this entity
  DateTimeColumn get date => dateTime()();
  TextColumn get activityName => text()();
  TextColumn get activityDescription => text()();
  TextColumn get photo => text().nullable()(); // local path(s), comma-separated, until uploaded
  TextColumn get bookDetails => text()();
  TextColumn get participantsGrades => text()();
  IntColumn get participantsNumber => integer()();
  TextColumn get conductedBy => text()();
  TextColumn get school => text()();
  IntColumn get createdBy => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {localId};
}