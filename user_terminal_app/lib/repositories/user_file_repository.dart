import 'dart:convert';
import 'dart:io';

import 'package:user_terminal_app/exceptions/exceptions.dart';
import 'package:user_terminal_app/models/user.dart';
import 'package:user_terminal_app/repositories/user_repository.dart';

enum StorageType {
  line,
  json;

  @override
  String toString() => name[0].toUpperCase() + name.substring(1);

  static StorageType fromString(String value) => StorageType.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
  );
}

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
    return await _userFileService.getUsertById(id: id, storage: _storage);
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
