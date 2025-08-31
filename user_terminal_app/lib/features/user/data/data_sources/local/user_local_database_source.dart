import 'package:drift/drift.dart';
import 'package:user_terminal_app/core/databases/local_database.dart';
import 'package:user_terminal_app/features/user/data/models/user.dart';
import 'package:user_terminal_app/features/user/data/models/user_mappers.dart';

class UserLocalDatabaseSource {
  final AppDatabase _database;

  UserLocalDatabaseSource(this._database);

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    try {
      final newUser = UserTableCompanion.insert(
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );
      await _database.into(_database.userTable).insert(newUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllUser() async {
    try {
      await _database.delete(_database.userTable).go();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser({required int id}) async {
    try {
      await (_database.delete(
        _database.userTable,
      )..where((u) => u.id.equals(id))).go();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getAllUser() async {
    try {
      final users = await _database.select(_database.userTable).get();
      return users.map((user) => user.toUserModel()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUsertById({required int id}) async {
    try {
      final user = await (_database.select(
        _database.userTable,
      )..where((u) => u.id.equals(id))).getSingle();
      return user.toUserModel();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    try {
      final updatedRows =
          await (_database.update(
            _database.userTable,
          )..where((u) => u.id.equals(id))).write(
            UserTableCompanion(
              firstName: firstName != null ? Value(firstName) : Value.absent(),
              lastName: lastName != null ? Value(lastName) : Value.absent(),
              birthYear: birthYear != null ? Value(birthYear) : Value.absent(),
              country: country != null ? Value(country) : Value.absent(),
            ),
          );

      return updatedRows > 0;
    } catch (e) {
      rethrow;
    }
  }
}
