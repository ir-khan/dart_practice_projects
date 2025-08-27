import 'dart:convert';
import 'dart:io';

import 'package:user_terminal_app/user/models/user.dart';

abstract class UserStorage {
  Future<List<User>> readAll();
  Future<void> writeAll(List<User> users);
  Future<void> clear();
}

class LineUserStorage implements UserStorage {
  final File _file = File('users.txt');

  LineUserStorage() {
    if (!_file.existsSync()) {
      _file.createSync();
    }
  }

  @override
  Future<List<User>> readAll() async {
    final content = await _file.readAsString();
    if (content.trim().isEmpty) return [];
    return content
        .split('${Platform.lineTerminator}${Platform.lineTerminator}')
        .where((block) => block.trim().isNotEmpty)
        .map(UserRaw.fromMultilineString)
        .toList();
  }

  @override
  Future<void> writeAll(List<User> users) async {
    final data = UserRaw.fromMultilineList(users);
    await _file.writeAsString(data, mode: FileMode.write);
  }

  @override
  Future<void> clear() async {
    await _file.writeAsString('', mode: FileMode.write);
  }
}

class JsonUserStorage implements UserStorage {
  final File _file = File('users.json');

  JsonUserStorage() {
    if (!_file.existsSync()) {
      _file.createSync();
      _file.writeAsStringSync('[]');
    }
  }

  @override
  Future<List<User>> readAll() async {
    final content = await _file.readAsString();
    if (content.trim().isEmpty) return [];
    return (jsonDecode(content) as List)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> writeAll(List<User> users) async {
    final data = jsonEncode(users.map((u) => u.toJson()).toList());
    await _file.writeAsString(data, mode: FileMode.write);
  }

  @override
  Future<void> clear() async {
    await _file.writeAsString('[]', mode: FileMode.write);
  }
}

class BinaryUserStorage implements UserStorage {
  final File _file = File('users.bin');

  BinaryUserStorage() {
    if (!_file.existsSync()) {
      _file.createSync();
    }
  }

  String _toBinary(int value, {int bits = 8}) =>
      value.toRadixString(2).padLeft(bits, '0');

  String _stringToBinary(String text) =>
      text.codeUnits.map((c) => _toBinary(c)).join(' ');

  String _binaryToString(String binary) => String.fromCharCodes(
    binary.split(' ').map((b) => int.parse(b, radix: 2)),
  );

  @override
  Future<List<User>> readAll() async {
    final content = await _file.readAsString();
    if (content.trim().isEmpty) return [];

    final blocks = content.split(
      '${Platform.lineTerminator}${Platform.lineTerminator}',
    );
    return blocks.where((block) => block.trim().isNotEmpty).map((block) {
      final lines = block.split(Platform.lineTerminator);

      final id = int.parse(lines[0], radix: 2);
      final firstName = _binaryToString(lines[1]);
      final lastName = _binaryToString(lines[2]);
      final birthYear = int.parse(lines[3], radix: 2);
      final country = _binaryToString(lines[4]);

      return User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthYear: birthYear,
        country: country,
      );
    }).toList();
  }

  @override
  Future<void> writeAll(List<User> users) async {
    final blocks = users
        .map((u) {
          return [
            _toBinary(u.id),
            _stringToBinary(u.firstName),
            _stringToBinary(u.lastName),
            _toBinary(u.birthYear, bits: 12),
            _stringToBinary(u.country),
          ].join(Platform.lineTerminator);
        })
        .join('${Platform.lineTerminator}${Platform.lineTerminator}');

    await _file.writeAsString(blocks, mode: FileMode.write);
  }

  @override
  Future<void> clear() async {
    await _file.writeAsString('', mode: FileMode.write);
  }
}
