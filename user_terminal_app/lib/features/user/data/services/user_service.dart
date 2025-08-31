import 'package:user_terminal_app/core/databases/local_database.dart';
import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/core/utils/validators.dart';
import 'package:user_terminal_app/features/user/data/data_sources/local/user_file_source.dart';
import 'package:user_terminal_app/features/user/data/data_sources/local/user_local_database_source.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_database_repository.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_file_repository.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_repository.dart';
import 'package:user_terminal_app/features/user/data/repositories/user_server_repository.dart';

class UserService {
  final List<String> _data;
  late final UserRepository _userRepository;
  AppDatabase? _database;

  UserService(this._data) {
    _initializeRepository();
  }

  void _initializeRepository() {
    late StorageType encoding;
    final encodingFlagIndex = _data.indexWhere((arg) => arg == '-e');
    final repoSource = RepositorySource.values.fromString(_data.first);

    if (encodingFlagIndex != -1) {
      if (_data.length < encodingFlagIndex + 2) {
        throw InvalidArgumentException(
          'Valid encoding arguments are: ${StorageType.values.join(', ')}. Used as -e line.',
        );
      }
      encoding = StorageType.values.fromString(_data[encodingFlagIndex + 1]);
    } else {
      encoding = StorageType.line;
    }

    switch (repoSource) {
      case RepositorySource.file:
        switch (encoding) {
          case StorageType.line:
            _userRepository = UserFileRepository(LineUserFileSource());
          case StorageType.json:
            _userRepository = UserFileRepository(JsonUserFileSource());
          case StorageType.binary:
            _userRepository = UserFileRepository(BinaryUserFileSource());
        }
        break;
      case RepositorySource.server:
        _userRepository = UserServerRepository();
        break;
      case RepositorySource.database:
        _database = AppDatabase();
        _userRepository = UserDatabaseRepository(
          UserLocalDatabaseSource(_database!),
        );
        break;
    }
  }

  Future<void> createUser() async {
    if (_data.length < 3) {
      throw TooLowArgumentsException(
        'Please provide user information after -u.',
      );
    }
    if (isValidUserInformation(_data[2])) {
      final user = _data[2].split(',');
      await _userRepository.createUser(
        firstName: user[0],
        lastName: user[1],
        birthYear: int.parse(user[2]),
        country: user[3],
      );
      print("User created successfully!");
    }
  }

  Future<void> findUser() async {
    if (_data.length < 3) {
      throw TooLowArgumentsException('Please provide a user ID to find.');
    }
    print(await _userRepository.getUsertById(id: validInt(_data[2])));
  }

  Future<void> listAllUsers() async {
    final users = await _userRepository.getAllUser();
    if (users.isEmpty) {
      print('No user found');
    }
    users.forEach(print);
  }

  Future<void> deleteUser() async {
    if (_data.length < 3) {
      throw TooLowArgumentsException('Please provide a user ID to delete.');
    }
    await _userRepository.deleteUser(id: validInt(_data[2]));
    print("User with id ${_data[2]} deleted successfully!");
  }

  Future<void> deleteAllUsers() async {
    await _userRepository.deleteAllUser();
    print("All users deleted successfully!");
  }

  Future<void> updateUser() async {
    if (_data.length < 4) {
      throw TooLowArgumentsException(
        'Please provide user ID and updated information.',
      );
    }
    if (isValidUserInformation(_data[3])) {
      final user = _data[3].split(',');
      final updated = await _userRepository.updateUser(
        id: validInt(_data[2]),
        firstName: user[0],
        lastName: user[1],
        birthYear: int.parse(user[2]),
        country: user[3],
      );
      if (updated) {
        print('User updated successfully!');
      }
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
