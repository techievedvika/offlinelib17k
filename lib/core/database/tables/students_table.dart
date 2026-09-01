import 'package:drift/drift.dart';

class Students extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get uuid => text()();
  TextColumn get apaarId => text().nullable()();
  TextColumn get penId => text().nullable()();
  TextColumn get uniqueId => text().nullable()();
  TextColumn get school => text()();
  TextColumn get name => text()();
  TextColumn get studentClass => text()();
  TextColumn get rollno => text()();
  TextColumn get gender => text()();
  TextColumn get status => text().nullable()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get createdBy => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {rollno};
}