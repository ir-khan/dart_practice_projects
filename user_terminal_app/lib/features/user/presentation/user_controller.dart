import 'dart:io';

import 'package:user_terminal_app/core/enums/enums.dart';
import 'package:user_terminal_app/core/exceptions/exceptions.dart';
import 'package:user_terminal_app/features/user/data/services/user_service.dart';

class UserController {
  final List<String> _data;

  UserController(this._data);

  Future<void> validate() async {
    final userService = UserService(_data);

    try {
      if (_data.isEmpty) {
        throw NoArgumentException('Please provide an arguments.');
      }

      if (_data.length == 1) {
        throw TooLowArgumentsException(
          'Please specify second argument to perform user\'s operations.',
        );
      } else if (_data.length > 6) {
        throw TooManyArgumentsException('You specified too many arguments.');
      }

      final arg = ValidUserArguments.values.fromString(_data[1]);

      switch (arg) {
        case ValidUserArguments.u:
          await userService.createUser();
          break;
        case ValidUserArguments.find:
          await userService.findUser();
          break;
        case ValidUserArguments.list:
          await userService.listAllUsers();
          break;
        case ValidUserArguments.del:
          await userService.deleteUser();
          break;
        case ValidUserArguments.delAll:
          await userService.deleteAllUsers();
          break;
        case ValidUserArguments.up:
          await userService.updateUser();
          break;
      }
    } on AppException catch (e) {
      print(e.toString());
      exit(-1);
    } finally {
      await userService.closeDatabase();
    }
  }
}

// import 'dart:io';

// import 'package:user_terminal_app/core/databases/local_database.dart';
// import 'package:user_terminal_app/core/enums/enums.dart';
// import 'package:user_terminal_app/core/exceptions/exceptions.dart';
// import 'package:user_terminal_app/core/utils/validators.dart';
// import 'package:user_terminal_app/features/user/data/data_sources/local/user_file_source.dart';
// import 'package:user_terminal_app/features/user/data/data_sources/local/user_local_database_source.dart';
// import 'package:user_terminal_app/features/user/data/repositories/user_database_repository.dart';
// import 'package:user_terminal_app/features/user/data/repositories/user_file_repository.dart';
// import 'package:user_terminal_app/features/user/data/repositories/user_repository.dart';
// import 'package:user_terminal_app/features/user/data/repositories/user_server_repository.dart';

// class UserController {
//   final List<String> _data;

//   const UserController(this._data);

//   void validate() async {
//     late UserRepository userRepository;
//     late StorageType encoding;
//     AppDatabase? database;

//     try {
//       if (_data.isEmpty) {
//         throw NoArgumentException('Please provide an arguments.');
//       }

//       if (_data.length == 1) {
//         throw TooLowArgumentsException(
//           'Please specify second argument to perform user\'s operations.',
//         );
//       } else if (_data.length > 6) {
//         throw TooManyArgumentsException('You specified too many arguments.');
//       }

//       final encodingFlagIndex = _data.indexWhere((arg) => arg == '-e');
//       if (encodingFlagIndex != -1) {
//         if (_data.length < encodingFlagIndex + 2) {
//           throw InvalidArgumentException(
//             'Valid encoding arguments are: ${StorageType.values.join(', ')}. Used as -e line.',
//           );
//         }
//         encoding = StorageType.values.fromString(_data[encodingFlagIndex + 1]);
//       } else {
//         encoding = StorageType.line;
//       }
//       final repoSource = RepositorySource.values.fromString(_data.first);

//       switch (repoSource) {
//         case RepositorySource.file:
//           switch (encoding) {
//             case StorageType.line:
//               userRepository = UserFileRepository(LineUserFileSource());
//             case StorageType.json:
//               userRepository = UserFileRepository(JsonUserFileSource());
//             case StorageType.binary:
//               userRepository = UserFileRepository(BinaryUserFileSource());
//           }
//           break;
//         case RepositorySource.server:
//           userRepository = UserServerRepository(
//             // chopper.getService<UserApiService>(),
//           );
//           break;
//         case RepositorySource.database:
//           database = AppDatabase();
//           userRepository = UserDatabaseRepository(
//             UserLocalDatabaseSource(database),
//           );
//           break;
//       }

//       final arg = ValidUserArguments.values.fromString(_data[1]);
//       switch (arg) {
//         case ValidUserArguments.u:
//           if (_data.length < 3) {
//             throw TooLowArgumentsException(
//               'Please provide user information after -u.',
//             );
//           }
//           if (isValidUserInformation(_data[2])) {
//             final user = _data[2].split(',');
//             await userRepository.createUser(
//               firstName: user[0],
//               lastName: user[1],
//               birthYear: int.parse(user[2]),
//               country: user[3],
//             );
//             print("User created successfully!");
//           }
//           break;
//         case ValidUserArguments.find:
//           if (_data.length < 3) {
//             throw TooLowArgumentsException('Please provide a user ID to find.');
//           }
//           print(await userRepository.getUsertById(id: validInt(_data[2])));
//           break;
//         case ValidUserArguments.list:
//           final users = await userRepository.getAllUser();
//           if (users.isEmpty) {
//             print('No user found');
//           }
//           users.forEach(print);
//           break;
//         case ValidUserArguments.del:
//           if (_data.length < 3) {
//             throw TooLowArgumentsException(
//               'Please provide a user ID to delete.',
//             );
//           }
//           await userRepository.deleteUser(id: validInt(_data[2]));
//           print("User with id ${_data[2]} deleted successfully!");
//           break;
//         case ValidUserArguments.delAll:
//           await userRepository.deleteAllUser();
//           print("All users deleted successfully!");
//           break;
//         case ValidUserArguments.up:
//           if (_data.length < 4) {
//             throw TooLowArgumentsException(
//               'Please provide user ID and updated information.',
//             );
//           }
//           if (isValidUserInformation(_data[3])) {
//             final user = _data[3].split(',');
//             final updated = await userRepository.updateUser(
//               id: validInt(_data[2]),
//               firstName: user[0],
//               lastName: user[1],
//               birthYear: int.parse(user[2]),
//               country: user[3],
//             );
//             if (updated) {
//               print('User updated successfully!');
//             }
//           }
//           break;
//       }
//     } on AppException catch (e) {
//       print(e.toString());
//       exit(-1);
//     } finally {
//       if (database != null) {
//         await database.close();
//       }
//     }
//   }
// }
