import 'package:drift/drift.dart';

class Books extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get isbn => text()();
  TextColumn get title => text()();
  TextColumn get publisher => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get gener => text().nullable()();
  TextColumn get level => text().nullable()();
  TextColumn get coverPage => text().nullable()(); // local path until uploaded, then server URL
  TextColumn get code => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {isbn};
}