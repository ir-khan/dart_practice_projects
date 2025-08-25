import 'package:user_terminal_app/models/user.dart';
import 'package:user_terminal_app/repositories/user_repository.dart';

class UserServerRepository implements UserRepository {
  // final UserApiService _userApi;

  // const UserServerRepository(this._userApi);
  @override
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required int birthYear,
    required String country,
  }) async {
    // try {
    //   await _userApi.createUser(
    //     body: {
    //       "firstName": firstName,
    //       "lastName": lastName,
    //       "birthYear": birthYear,
    //       "country": country,
    //     },
    //   );
    // } catch (e) {
    //   rethrow;
    // }

    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllUser() async {
    // try {
    //   final users = await getAllUser();
    //   for (var user in users) {
    //     deleteUser(id: user.id);
    //   }
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser({required int id}) async {
    // try {
    //   await _userApi.deleteUser(id: id);
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  @override
  Future<User> getUsertById({required int id}) async {
    // try {
    //   final response = await _userApi.geUsertById(id: id);
    //   return User.fromJson(response.body);
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAllUser() async {
    // try {
    //   final response = await _userApi.getAllUser();
    //   return (response.body as List).map((e) => User.fromJson(e)).toList();
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser({
    required int id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? country,
  }) async {
    // try {
    //   await _userApi.updateUser(
    //     id: id,
    //     body: {
    //       "firstName": firstName,
    //       "lastName": lastName,
    //       "birthYear": birthYear,
    //       "country": country,
    //     },
    //   );
    //   return true;
    // } catch (e) {
    //   rethrow;
    // }
    throw UnimplementedError();
  }
}
