import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:user_terminal_app/features/user/data/models/user_table.dart';

part 'local_database.g.dart';


@DriftDatabase(tables: [UserTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() =>
      NativeDatabase.createInBackground(File('storage/sqlite.db'));
}
