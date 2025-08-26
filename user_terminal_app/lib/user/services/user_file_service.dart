import 'dart:convert';
import 'dart:io';

import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/user/models/user.dart';

class UserFileService {
  final File _userTxt = File('users.txt');
  final File _userJson = File('users.json');
  final File _userBinary = File('users.bin');

  UserFileService._();

  static Future<UserFileService> init() async {
    final service = UserFileService._();
    await service._checkFilesExists();
    return service;
  }

  Future<void> _checkFilesExists() async {
    try {
      final files = [_userTxt, _userJson, _userBinary];
      await Future.wait(
        files.map((f) async {
          if (!await f.exists()) {
            await f.create();
          }
        }),
      );
    } on FileSystemException {
      rethrow;
    }
  }

  Future<List<User>> _readFiles(StorageType storage) async {
    List<User> users;

    switch (storage) {
      case StorageType.line:
        final lines = await _userTxt.readAsLines();
        users = lines
            .where((line) => line.trim().isNotEmpty)
            .map(UserRaw.fromRawString)
            .toList();
        break;

      case StorageType.json:
        final content = await _userJson.readAsString();
        if (content.trim().isEmpty) return [];
        users = (jsonDecode(content) as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
        break;

      case StorageType.binary:
        final bytes = await _userBinary.readAsBytes();
        if (bytes.isEmpty) return [];
        final content = utf8.decode(bytes, allowMalformed: true);
        users = content
            .split(Platform.lineTerminator)
            .where((line) => line.trim().isNotEmpty)
            .map(UserRaw.fromRawString)
            .toList();
        break;

      case StorageType.all:
        final results = await Future.wait([
          _readFiles(StorageType.line),
          _readFiles(StorageType.json),
          _readFiles(StorageType.binary),
        ]);

        final allUsers = <int, User>{};
        for (final list in results) {
          for (final user in list) {
            allUsers[user.id] = user;
          }
        }
        users = allUsers.values.toList();
        break;
    }
    users.sort((a, b) => a.id.compareTo(b.id));
    return users;
  }

  Future<void> _writeFiles(List<User> users, StorageType storage) async {
    switch (storage) {
      case StorageType.line:
        final data = UserRaw.fromList(users);
        await _userTxt.writeAsString(data, mode: FileMode.writeOnly);
        break;

      case StorageType.json:
        final data = jsonEncode(users.map((u) => u.toJson()).toList());
        await _userJson.writeAsString(data, mode: FileMode.writeOnly);
        break;

      case StorageType.binary:
        final data = utf8.encode(UserRaw.fromList(users));
        await _userBinary.writeAsBytes(data, mode: FileMode.writeOnly);
        break;

      case StorageType.all:
        await Future.wait([
          _writeFiles(users, StorageType.line),
          _writeFiles(users, StorageType.json),
          _writeFiles(users, StorageType.binary),
        ]);
        break;
    }
  }

  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
    required StorageType storage,
  }) async {
    try {
      final allUsers = await _readFiles(StorageType.all);
      final id = allUsers.isEmpty ? 1 : allUsers.last.id + 1;

      final newUser = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );

      final users = await _readFiles(storage);
      users.add(newUser);
      await _writeFiles(users, storage);
    } on FileSystemException {
      throw FileException('Can\'t create new user in file.');
    }
  }

  Future<User> getUserById({
    required int id,
    required StorageType storage,
  }) async {
    try {
      final users = await _readFiles(storage);
      return users.firstWhere(
        (u) => u.id == id,
        orElse: () => throw NotFoundException('User with id $id not found.'),
      );
    } on FileSystemException {
      throw FileException('Unable to get user by id.');
    }
  }

  Future<List<User>> getAllUser({required StorageType storage}) async {
    try {
      return await _readFiles(storage);
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
      final users = await _readFiles(storage);
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
      await _writeFiles(users, storage);
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
      final users = await _readFiles(storage);
      final initialLength = users.length;

      users.removeWhere((u) => u.id == id);

      if (users.length == initialLength) {
        throw NotFoundException('User with id $id not found.');
      }

      await _writeFiles(users, storage);
    } on FileSystemException {
      throw FileException('Unable to delete user by id.');
    }
  }

  Future<void> deleteAllUser({required StorageType storage}) async {
    try {
      switch (storage) {
        case StorageType.line:
          await _userTxt.writeAsString('', mode: FileMode.write);
          break;
        case StorageType.json:
          await _userJson.writeAsString('[]', mode: FileMode.write);
          break;
        case StorageType.binary:
          await _userBinary.writeAsBytes([], mode: FileMode.write);
          break;
        case StorageType.all:
          await Future.wait([
            deleteAllUser(storage: StorageType.line),
            deleteAllUser(storage: StorageType.json),
            deleteAllUser(storage: StorageType.binary),
          ]);
          break;
      }
    } on FileSystemException {
      throw FileException('Unable to delete all users.');
    }
  }
}
