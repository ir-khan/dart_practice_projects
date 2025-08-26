import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'local_database.g.dart';

class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  IntColumn get birthYear => integer()();
  TextColumn get country => text()();
}

@DriftDatabase(tables: [UserTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() =>
      NativeDatabase.createInBackground(File('sqlite.db'));
}
