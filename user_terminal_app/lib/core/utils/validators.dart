import 'package:user_terminal_app/core/exceptions/exceptions.dart';

final validUserInformationFormat = RegExp(
  r"^[a-zA-Z]+,[a-zA-Z]+,[0-9]{4},[a-zA-Z]+$",
);

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