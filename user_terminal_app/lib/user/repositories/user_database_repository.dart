import 'package:drift/drift.dart';
import 'package:user_terminal_app/core/databases/local_database.dart' as db;
import 'package:user_terminal_app/user/mappers/user_mapper.dart';
import 'package:user_terminal_app/user/models/user.dart';
import 'package:user_terminal_app/user/repositories/user_repository.dart';

class UserDatabaseRepository implements UserRepository {
  final db.AppDatabase database;

  UserDatabaseRepository(this.database);
  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    try {
      final newUser = db.UsersCompanion.insert(
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );
      await database.into(database.users).insert(newUser);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllUser() async {
    try {
      final users = await getAllUser();
      for (var user in users) {
        await deleteUser(id: user.id);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser({required int id}) async {
    try {
      await (database.delete(
        database.users,
      )..where((u) => u.id.equals(id))).go();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> getAllUser() async {
    try {
      final users = await database.select(database.users).get();
      return users.map((user) => user.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUsertById({required int id}) async {
    try {
      final user = await (database.select(
        database.users,
      )..where((u) => u.id.equals(id))).getSingle();
      return user.toDomain();
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
            database.users,
          )..where((u) => u.id.equals(id))).write(
            db.UsersCompanion(
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
