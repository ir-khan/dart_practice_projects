import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_terminal_app/exceptions/exceptions.dart';

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
  String toRawString() =>
      '$id|$firstName|$lastName|$birthYear|$country${Platform.lineTerminator}';

  static String fromList(List<User> users) {
    return users.map((user) => user.toRawString()).toList().join();
  }

  static User fromRawString(String raw) {
    final parts = raw.split('|');
    if (parts.length != 5) {
      throw InvalidUserInformationException('Invalid raw user string: $raw');
    }
    return User(
      id: int.parse(parts[0]),
      firstName: parts[1],
      lastName: parts[2],
      birthYear: int.parse(parts[3]),
      country: parts[4],
    );
  }
}
