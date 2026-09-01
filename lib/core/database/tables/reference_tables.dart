import 'package:drift/drift.dart';

// Pull-only caches — no sync metadata, wholesale overwrite on each pull

class Grades extends Table {
  TextColumn get grade => text()();
  @override
  Set<Column> get primaryKey => {grade};
}

class SchoolBasicCache extends Table {
  TextColumn get schoolPid => text()();
  TextColumn get state => text()();
  TextColumn get distName => text()();
  TextColumn get schoolCodeNew => text()();
  TextColumn get schoolName => text()();
  TextColumn get blockName => text()();

  @override
  Set<Column> get primaryKey => {schoolPid};
}

class GeneralLinksCache extends Table {
  TextColumn get key => text()(); // 'lib_version', 'apk_url', etc.
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}