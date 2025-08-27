import 'dart:io';

import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/user/models/user.dart';
import 'package:user_terminal_app/user/repositories/user_repository.dart';
import 'package:user_terminal_app/user/services/user_storage.dart';

class UserFileRepository implements UserRepository {
  final UserStorage _userStorage;

  const UserFileRepository(this._userStorage);

  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    try {
      final users = await _userStorage.readAll();
      final id = users.isEmpty ? 1 : users.last.id + 1;

      final newUser = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );

      users.add(newUser);
      await _userStorage.writeAll(users);
    } on FileSystemException {
      throw FileException('Unable to create user.');
    }
  }

  @override
  Future<void> deleteAllUser() async {
    await _userStorage.clear();
  }

  @override
  Future<void> deleteUser({required int id}) async {
    final users = await _userStorage.readAll();
    final initialLength = users.length;

    users.removeWhere((u) => u.id == id);

    if (users.length == initialLength) {
      throw NotFoundException('User with id $id not found.');
    }

    await _userStorage.writeAll(users);
  }

  @override
  Future<User> getUsertById({required int id}) async {
    final users = await _userStorage.readAll();
    return users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw NotFoundException('User with id $id not found.'),
    );
  }

  @override
  Future<List<User>> getAllUser() async {
    return await _userStorage.readAll();
  }

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    final users = await _userStorage.readAll();
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
    await _userStorage.writeAll(users);
    return true;
  }
}
