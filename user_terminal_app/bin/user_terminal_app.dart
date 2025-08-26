import 'dart:io';

import 'package:user_terminal_app/core/databases/local_database.dart';
import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/core/utils/validators.dart';
import 'package:user_terminal_app/user/repositories/user_database_repository.dart';
import 'package:user_terminal_app/user/repositories/user_file_repository.dart';
import 'package:user_terminal_app/user/repositories/user_repository.dart';
import 'package:user_terminal_app/user/repositories/user_server_repository.dart';
import 'package:user_terminal_app/user/services/user_file_service.dart';

// final chopper = ChopperClient(
//   baseUrl: Uri.parse("http://localhost:3000"),
//   services: [UserApiService.create()],
//   converter: JsonConverter(),
//   interceptors: [HttpLoggingInterceptor()],
// );

void main(List<String> arguments) async {
  late UserRepository userRepository;
  late StorageType encoding;
  late AppDatabase? database;

  try {
    if (arguments.isEmpty) {
      throw NoArgumentException('Please provide an arguments.');
    }

    final encodingFlagIndex = arguments.indexWhere((arg) => arg == '-e');
    if (encodingFlagIndex != -1) {
      if (arguments.length < encodingFlagIndex + 2) {
        throw InvalidArgumentException(
          'Valid encoding arguments are: ${StorageType.values.join(', ')}. Used as -e line.',
        );
      }
      encoding = StorageType.values.fromString(
        arguments[encodingFlagIndex + 1],
      );
    } else {
      encoding = StorageType.line;
    }

    final repoSource = RepositorySource.values.fromString(arguments.first);

    switch (repoSource) {
      case RepositorySource.file:
        userRepository = UserFileRepository(
          await UserFileService.init(),
          storage: encoding,
        );
        break;
      case RepositorySource.server:
        userRepository = UserServerRepository(
          // chopper.getService<UserApiService>(),
        );
        break;
      case RepositorySource.database:
        database = AppDatabase();
        userRepository = UserDatabaseRepository(database);
        break;
    }

    if (arguments.length == 1) {
      throw TooLowArgumentsException(
        'Please specify second argument to perform user\'s operations.',
      );
    } else if (arguments.length > 6) {
      throw TooManyArgumentsException('You specified too many arguments.');
    }

    final arg = ValidUserArguments.values.fromString(arguments[1]);

    switch (arg) {
      case ValidUserArguments.u:
        if (arguments.length < 3) {
          throw TooLowArgumentsException(
            'Please provide user information after -u.',
          );
        }
        if (isValidUserInformation(arguments[2])) {
          final user = arguments[2].split(',');
          await userRepository.createUser(
            firstName: user[0],
            lastName: user[1],
            birthYear: int.parse(user[2]),
            country: user[3],
          );
          print("User created successfully!");
        }
        break;
      case ValidUserArguments.find:
        if (arguments.length < 3) {
          throw TooLowArgumentsException('Please provide a user ID to find.');
        }
        print(await userRepository.getUsertById(id: validInt(arguments[2])));
        break;
      case ValidUserArguments.list:
        final users = await userRepository.getAllUser();
        if (users.isEmpty) {
          print('No user found');
        }
        users.forEach(print);
        break;
      case ValidUserArguments.del:
        if (arguments.length < 3) {
          throw TooLowArgumentsException('Please provide a user ID to delete.');
        }
        await userRepository.deleteUser(id: validInt(arguments[2]));
        print("User with id ${arguments[2]} deleted successfully!");
        break;
      case ValidUserArguments.delAll:
        await userRepository.deleteAllUser();
        print("All users deleted successfully!");
        break;
      case ValidUserArguments.up:
        if (arguments.length < 4) {
          throw TooLowArgumentsException(
            'Please provide user ID and updated information.',
          );
        }
        if (isValidUserInformation(arguments[3])) {
          final user = arguments[3].split(',');
          final updated = await userRepository.updateUser(
            id: validInt(arguments[2]),
            firstName: user[0],
            lastName: user[1],
            birthYear: int.parse(user[2]),
            country: user[3],
          );
          if (updated) {
            print('User updated successfully!');
          }
        }
        break;
    }
  } on AppException catch (e) {
    print(e.toString());
    exit(-1);
  } finally {
    if (database != null) {
      await database.close();
    }
  }
}
