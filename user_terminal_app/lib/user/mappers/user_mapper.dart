import 'package:user_terminal_app/core/databases/local_database.dart';
import 'package:user_terminal_app/user/models/user.dart';

extension UserDataMapper on UserTableData {
  User toUserModel() => User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthYear: birthYear,
    country: country,
  );
}
