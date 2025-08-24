import 'dart:io';

import 'package:user_terminal_app/exceptions/exceptions.dart';
import 'package:user_terminal_app/models/user.dart';

class UserFileService {
  final File _userFile = File('users.txt');

  UserFileService() {
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    try {
      if (!await _userFile.exists()) {
        await _userFile.create();
      }
    } on FileSystemException {
      rethrow;
    }
  }

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    try {
      final users = await getAllUser();
      final int id;
      if (users.isEmpty) {
        id = 1;
      } else {
        id = users.last.id + 1;
      }
      final newUser = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );
      await _userFile.writeAsString(
        newUser.toRawString(),
        mode: FileMode.writeOnlyAppend,
      );
    } on FileSystemException {
      throw FileException('Can\'t able to create new user in file.');
    }
  }

  Future<User> geUsertById({required int id}) async {
    try {
      final users = await getAllUser();
      return users.firstWhere((user) => user.id == id);
    } on FileSystemException {
      throw FileException('Unable to get user by id.');
    }
  }

  Future<List<User>> getAllUser() async {
    try {
      await _checkFileExists();
      final lines = await _userFile.readAsLines();
      return lines.map((e) => UserRaw.fromRawString(e)).toList();
    } on FileSystemException {
      throw FileException('Unable to get all user.');
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
      final users = await getAllUser();
      final userIndex = users.indexWhere((user) => user.id == id);
      final newUser = User(
        id: users[userIndex].id,
        firstName: firstName ?? users[userIndex].firstName,
        lastName: lastName ?? users[userIndex].lastName,
        birthYear: birthYear ?? users[userIndex].birthYear,
        country: country ?? users[userIndex].country,
      );
      users.removeAt(userIndex);
      users.insert(userIndex, newUser);
      await _userFile.writeAsString(
        UserRaw.fromList(users),
        mode: FileMode.writeOnly,
      );
      return true;
    } on FileSystemException {
      throw FileException('Unable to update user by id.');
    }
  }

  Future<void> deleteUser({required int id}) async {
    try {
      final users = await getAllUser();
      users.removeWhere((user) => user.id == id);
      await _userFile.writeAsString(
        UserRaw.fromList(users),
        mode: FileMode.writeOnly,
      );
    } on FileSystemException {
      throw FileException('Unable to delete user by id.');
    }
  }

  Future<void> deleteAllUser() async {
    try {
      await _userFile.writeAsString('', mode: FileMode.writeOnly);
    } on FileSystemException {
      throw FileException('Unable to delete all users.');
    }
  }
}
