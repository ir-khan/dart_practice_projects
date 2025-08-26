import 'package:user_terminal_app/core/databases/local_database.dart' as db;
import 'package:user_terminal_app/user/models/user.dart';

extension UserDataMapper on db.User {
  User toDomain() => User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthYear: birthYear,
    country: country,
  );
}
