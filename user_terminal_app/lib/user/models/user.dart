import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

extension UserRaw on User {
  String toMultilineString() =>
      '$id${Platform.lineTerminator}$firstName${Platform.lineTerminator}$lastName${Platform.lineTerminator}$birthYear${Platform.lineTerminator}$country${Platform.lineTerminator}${Platform.lineTerminator}';

  static String fromMultilineList(List<User> users) {
    return users.map((user) => user.toMultilineString()).join();
  }

  static User fromMultilineString(String block) {
    final lines = block
        .split(Platform.lineTerminator)
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.length != 5) {
      throw InvalidUserInformationException(
        'Invalid multiline user block: $block',
      );
    }
    return User(
      id: int.parse(lines[0]),
      firstName: lines[1],
      lastName: lines[2],
      birthYear: int.parse(lines[3]),
      country: lines[4],
    );
  }
}
