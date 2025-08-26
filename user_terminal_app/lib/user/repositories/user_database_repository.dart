import 'package:drift/drift.dart';
import 'package:user_terminal_app/core/databases/local_database.dart';
import 'package:user_terminal_app/user/mappers/user_mapper.dart';
import 'package:user_terminal_app/user/models/user.dart';
import 'package:user_terminal_app/user/repositories/user_repository.dart';

class UserDatabaseRepository implements UserRepository {
  final AppDatabase database;

  UserDatabaseRepository(this.database);
  @override
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
      await database.into(database.userTable).insert(newUser);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllUser() async {
    try {
      await database.delete(database.userTable).go();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser({required int id}) async {
    try {
      await (database.delete(
        database.userTable,
      )..where((u) => u.id.equals(id))).go();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> getAllUser() async {
    try {
      final users = await database.select(database.userTable).get();
      return users.map((user) => user.toUserModel()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUsertById({required int id}) async {
    try {
      final user = await (database.select(
        database.userTable,
      )..where((u) => u.id.equals(id))).getSingle();
      return user.toUserModel();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    try {
      final updatedRows =
          await (database.update(
            database.userTable,
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
