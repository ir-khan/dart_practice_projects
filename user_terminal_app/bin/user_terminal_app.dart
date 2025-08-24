import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:user_terminal_app/apis/user_api_service.dart';
import 'package:user_terminal_app/exceptions/exceptions.dart';
import 'package:user_terminal_app/local/user_file_service.dart';
import 'package:user_terminal_app/repositories/user_file_repository.dart';
import 'package:user_terminal_app/repositories/user_repository.dart';
import 'package:user_terminal_app/repositories/user_server_repository.dart';

const validUserArguments = <String>[
  '-u',
  '--find',
  '--list',
  '--del',
  '--del-all',
  '--up',
];
final validUserInformationFormat = RegExp(
  r"^[a-zA-Z]+,[a-zA-Z]+,[0-9]{4},[a-zA-Z]+$",
);
final chopper = ChopperClient(
  baseUrl: Uri.parse("http://localhost:3000"),
  services: [UserApiService.create()],
  converter: JsonConverter(),
  interceptors: [HttpLoggingInterceptor()],
);

void main(List<String> arguments) async {
  late UserRepository userRepository;
  try {
    if (arguments.isEmpty) {
      throw NoArgumentException('Please provide an arguments.');
    } else if (arguments.length == 1) {
      throw TooLowArgumentsException(
        'Please specify second argument to perform user\'s operations.',
      );
    } else if (arguments.length > 4) {
      throw TooManyArgumentsException('You specified too many arguments.');
    }

    if (arguments.first == '-f') {
      userRepository = UserFileRepository(UserFileService());
    } else if (arguments.first == '-s') {
      userRepository = UserServerRepository(
        chopper.getService<UserApiService>(),
      );
    } else {
      throw InvalidArgumentException('The first argument should be -f or -s');
    }

    if (!validUserArguments.contains(arguments[1])) {
      throw InvalidArgumentException(
        'Valid second arrguments are: ${validUserArguments.join(', ')}',
      );
    }

    if ((arguments[1] == validUserArguments[0] ||
            arguments[1] == validUserArguments[1] ||
            arguments[1] == validUserArguments[3] ||
            arguments[1] == validUserArguments[5]) &&
        arguments.length == 2) {
      throw TooLowArgumentsException(
        'Please provide appropriate user information after ${arguments[1]}.',
      );
    }

    if (arguments[1] == validUserArguments[0]) {
      if (isValidUserInformation(arguments[2])) {
        final user = arguments[2].split(',');

        await userRepository.createUser(
          firstName: user[0],
          lastName: user[1],
          birthYear: int.parse(user[2]),
          country: user[3],
        );
        print("User created successfully!");
        return;
      }
    } else if (arguments[1] == validUserArguments[1]) {
      print(await userRepository.getUsertById(id: validInt(arguments[2])));
    } else if (arguments[1] == validUserArguments[2] && arguments.length == 2) {
      userRepository.getAllUser().then((users) {
        if (users.isEmpty) {
          print('No user found');
          return;
        }
        users.forEach(print);
      });
      return;
    } else if (arguments[1] == validUserArguments[3]) {
      await userRepository.deleteUser(id: validInt(arguments[2]));
      print("User with id ${arguments[2]} deleted successfully!");
      return;
    } else if (arguments[1] == validUserArguments[4] && arguments.length == 2) {
      await userRepository.deleteAllUser();
      print("All users deleted successfully!");
      return;
    } else if (arguments[1] == validUserArguments[5]) {
      if (arguments.length < 4) {
        throw TooLowArgumentsException('You specified too low arguments.');
      }
      if (isValidUserInformation(arguments[3])) {
        final user = arguments[3].split(',');

        if (await userRepository.updateUser(
          id: validInt(arguments[2]),
          firstName: user[0],
          lastName: user[1],
          birthYear: int.parse(user[2]),
          country: user[3],
        )) {
          print('User update succesfully!');
        }
        return;
      }
    } else {
      if (arguments.length != 2) {
        throw TooManyArgumentsException('You specified too many arguments.');
      }
    }
  } on AppException catch (e) {
    print(e.toString());
    exit(-1);
  }
}

int validInt(String string) {
  try {
    return int.parse(string);
  } on FormatException {
    throw InvalidArgumentException(
      'Provide a valid integer to process certain user.',
    );
  }
}

bool isValidUserInformation(String source) {
  if (validUserInformationFormat.hasMatch(source)) return true;
  throw InvalidUserInformationException(
    'The user information should be in the following format "firstname,lastname,birthyear,country"',
  );
}
