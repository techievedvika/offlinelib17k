import 'package:drift/drift.dart';

class BookIssues extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get uniqid => text()();
  TextColumn get uuid => text()(); // mirrors uniqid, future-proofing
  TextColumn get bookIsbn => text()();
  TextColumn get bookName => text()();
  TextColumn get studentRollno => text()();
  TextColumn get studentGrade => text()();
  TextColumn get status => text()(); // 'Issued' | 'Returned'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()(); // == createdAt, set once, insert-only ledger
  DateTimeColumn get submittedAt => dateTime().nullable()();
  IntColumn get createdBy => integer()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  // uniqid is NOT unique here — the same uniqid appears twice
  // (once for Issued, once for Returned), so no primary key on uniqid alone.
  // Use an auto-increment local rowid instead.
  IntColumn get localRowId => integer().autoIncrement()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {uniqid, status}, // NEW — the real server-side identity of a row
  ];
}