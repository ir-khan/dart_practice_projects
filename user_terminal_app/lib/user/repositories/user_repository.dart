import 'package:user_terminal_app/user/models/user.dart';

abstract interface class UserRepository {
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  });
  Future<User> getUsertById({required int id});
  Future<List<User>> getAllUser();
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  });
  Future<void> deleteUser({required int id});
  Future<void> deleteAllUser();
}
