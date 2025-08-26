import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/user/models/user.dart';
import 'package:user_terminal_app/user/repositories/user_repository.dart';
import 'package:user_terminal_app/user/services/user_file_service.dart';

class UserFileRepository implements UserRepository {
  final UserFileService _userFileService;
  final StorageType _storage;

  const UserFileRepository(
    this._userFileService, {
    StorageType storage = StorageType.line,
  }) : _storage = storage;

  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    await _userFileService.createUser(
      firstName: firstName,
      lastName: lastName,
      birthYear: birthYear,
      country: country,
      storage: _storage,
    );
  }

  @override
  Future<void> deleteAllUser() async {
    await _userFileService.deleteAllUser(storage: _storage);
  }

  @override
  Future<void> deleteUser({required int id}) async {
    await _userFileService.deleteUser(id: id, storage: _storage);
  }

  @override
  Future<User> getUsertById({required int id}) async {
    return await _userFileService.getUserById(id: id, storage: _storage);
  }

  @override
  Future<List<User>> getAllUser() async {
    return await _userFileService.getAllUser(storage: _storage);
  }

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    return await _userFileService.updateUser(
      id: id,
      firstName: firstName,
      lastName: lastName,
      birthYear: birthYear,
      country: country,
      storage: _storage,
    );
  }
}
