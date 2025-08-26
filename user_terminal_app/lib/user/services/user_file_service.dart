import 'dart:convert';
import 'dart:io';

import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/user/models/user.dart';

class UserFileService {
  final File _userTxt = File('users.txt');
  final File _userJson = File('users.json');

  UserFileService._();

  static Future<UserFileService> init() async {
    final service = UserFileService._();
    await service._checkFilesExists();
    return service;
  }

  Future<void> _checkFilesExists() async {
    try {
      final files = [_userTxt, _userJson];

      final exists = await Future.wait(files.map((f) => f.exists()));

      await Future.wait([
        for (var i = 0; i < files.length; i++)
          if (!exists[i]) files[i].create(),
      ]);
    } on FileSystemException {
      rethrow;
    }
  }

  File _getFile(StorageType storage) => switch (storage) {
    StorageType.line => _userTxt,
    StorageType.json => _userJson,
  };

  Future<List<User>> _readUsers(StorageType storage) async {
    final file = _getFile(storage);
    final content = await file.readAsString();

    if (content.trim().isEmpty) return [];

    return switch (storage) {
      StorageType.line =>
        file
            .readAsLinesSync()
            .where((line) => line.trim().isNotEmpty)
            .map(UserRaw.fromRawString)
            .toList(),
      StorageType.json =>
        (jsonDecode(content) as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
    };
  }

  Future<void> _writeUsers(List<User> users, StorageType storage) async {
    final file = _getFile(storage);
    final data = switch (storage) {
      StorageType.line => UserRaw.fromList(users),
      StorageType.json => jsonEncode(users.map((u) => u.toJson()).toList()),
    };
    await file.writeAsString(data, mode: FileMode.writeOnly);
  }

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
    required StorageType storage,
  }) async {
    try {
      final users = await _readUsers(storage);
      final id = users.isEmpty ? 1 : users.last.id + 1;

      final newUser = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );

      users.add(newUser);
      await _writeUsers(users, storage);
    } on FileSystemException {
      throw FileException('Can\'t able to create new user in file.');
    }
  }

  Future<User> getUsertById({
    required int id,
    required StorageType storage,
  }) async {
    try {
      final users = await _readUsers(storage);
      return users.firstWhere((u) => u.id == id);
    } on StateError {
      throw FileException('User with id $id not found.');
    } on FileSystemException {
      throw FileException('Unable to get user by id.');
    }
  }

  Future<List<User>> getAllUser({required StorageType storage}) async {
    try {
      return await _readUsers(storage);
    } on FileSystemException {
      throw FileException('Unable to get all user.');
    }
  }

  Future<bool> updateUser({
    required int id,
    required StorageType storage,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    try {
      final users = await _readUsers(storage);
      final index = users.indexWhere((u) => u.id == id);

      if (index == -1) return false;

      final updatedUser = User(
        id: id,
        firstName: firstName ?? users[index].firstName,
        lastName: lastName ?? users[index].lastName,
        birthYear: birthYear ?? users[index].birthYear,
        country: country ?? users[index].country,
      );

      users[index] = updatedUser;
      await _writeUsers(users, storage);
      return true;
    } on FileSystemException {
      throw FileException('Unable to update user by id.');
    }
  }

  Future<void> deleteUser({
    required int id,
    required StorageType storage,
  }) async {
    try {
      final users = await _readUsers(storage);
      users.removeWhere((u) => u.id == id);
      await _writeUsers(users, storage);
    } on FileSystemException {
      throw FileException('Unable to delete user by id.');
    }
  }

  Future<void> deleteAllUser({required StorageType storage}) async {
    try {
      await _getFile(storage).writeAsString('', mode: FileMode.writeOnly);
    } on FileSystemException {
      throw FileException('Unable to delete all users.');
    }
  }
}
