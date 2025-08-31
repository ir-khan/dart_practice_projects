import 'package:user_terminal_app/features/user/data/data_sources/local/user_local_database_source.dart';
import 'package:user_terminal_app/features/user/data/models/user.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_repository.dart';

class UserDatabaseRepository implements UserRepository {
  final UserLocalDatabaseSource _userLocalDatabaseSource;

  UserDatabaseRepository(this._userLocalDatabaseSource);
  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) => _userLocalDatabaseSource.createUser(
    firstName: firstName,
    lastName: lastName,
    birthYear: birthYear,
    country: country,
  );

  @override
  Future<void> deleteAllUser() => _userLocalDatabaseSource.deleteAllUser();

  @override
  Future<void> deleteUser({required int id}) =>
      _userLocalDatabaseSource.deleteUser(id: id);

  @override
  Future<List<User>> getAllUser() => _userLocalDatabaseSource.getAllUser();

  @override
  Future<User> getUsertById({required int id}) =>
      _userLocalDatabaseSource.getUsertById(id: id);

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) => _userLocalDatabaseSource.updateUser(id: id);
}
