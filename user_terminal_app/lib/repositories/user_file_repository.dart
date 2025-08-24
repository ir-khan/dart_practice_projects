import 'package:user_terminal_app/local/user_file_service.dart';
import 'package:user_terminal_app/models/user.dart';
import 'package:user_terminal_app/repositories/user_repository.dart';

class UserFileRepository implements UserRepository {
  final UserFileService _userFileService;

  const UserFileRepository(this._userFileService);
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
    );
  }

  @override
  Future<void> deleteAllUser() async {
    await _userFileService.deleteAllUser();
  }

  @override
  Future<void> deleteUser({required int id}) async {
    await _userFileService.deleteUser(id: id);
  }

  @override
  Future<User> getUsertById({required int id}) async {
    return await _userFileService.geUsertById(id: id);
  }

  @override
  Future<List<User>> getAllUser() async {
    return await _userFileService.getAllUser();
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
    );
  }
}
