abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

class NoArgumentException extends AppException {
  const NoArgumentException([super.message = 'No arguments provided.']);
}

class InvalidArgumentException extends AppException {
  const InvalidArgumentException([
    super.message = 'Invalid arguments provided.',
  ]);
}

class TooLowArgumentsException extends AppException {
  const TooLowArgumentsException([
    super.message = 'The No. of argument is too low.',
  ]);
}

class TooManyArgumentsException extends AppException {
  const TooManyArgumentsException([
    super.message = 'The No. of argument is too many.',
  ]);
}

class InvalidUserInformationException extends AppException {
  const InvalidUserInformationException([
    super.message = 'Invalid user information provided.',
  ]);
}

class FileException extends AppException {
  const FileException([
    super.message = 'Something went wrong while dealing with file.',
  ]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not Found']);
}
