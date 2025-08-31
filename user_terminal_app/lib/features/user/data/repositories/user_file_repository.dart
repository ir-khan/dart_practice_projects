import 'dart:io';

import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/features/user/data/models/user.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_repository.dart';
import 'package:user_terminal_app/features/user/data/data_sources/local/user_file_source.dart';

class UserFileRepository implements UserRepository {
  final UserFileSource _userFileSource;

  const UserFileRepository(this._userFileSource);

  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    try {
      final users = await _userFileSource.readAll();
      final id = users.isEmpty ? 1 : users.last.id + 1;

      final newUser = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );

      users.add(newUser);
      await _userFileSource.writeAll(users);
    } on FileSystemException {
      throw FileException('Unable to create user.');
    }
  }

  @override
  Future<void> deleteAllUser() async {
    await _userFileSource.clear();
  }

  @override
  Future<void> deleteUser({required int id}) async {
    final users = await _userFileSource.readAll();
    final initialLength = users.length;

    users.removeWhere((u) => u.id == id);

    if (users.length == initialLength) {
      throw NotFoundException('User with id $id not found.');
    }

    await _userFileSource.writeAll(users);
  }

  @override
  Future<User> getUsertById({required int id}) async {
    final users = await _userFileSource.readAll();
    return users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw NotFoundException('User with id $id not found.'),
    );
  }

  @override
  Future<List<User>> getAllUser() async {
    return await _userFileSource.readAll();
  }

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    final users = await _userFileSource.readAll();
    final index = users.indexWhere((u) => u.id == id);

    if (index == -1) {
      throw NotFoundException('User with id $id not found.');
    }

    final updatedUser = User(
      id: id,
      firstName: firstName ?? users[index].firstName,
      lastName: lastName ?? users[index].lastName,
      birthYear: birthYear ?? users[index].birthYear,
      country: country ?? users[index].country,
    );

    users[index] = updatedUser;
    await _userFileSource.writeAll(users);
    return true;
  }
}
