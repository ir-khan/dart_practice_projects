import 'package:user_terminal_app/core/exceptions/exceptions.dart';

mixin ParseableEnum {
  String get rawValue;
}

enum RepositorySource with ParseableEnum {
  file('-f'),
  server('-s'),
  database('-d');

  @override
  final String rawValue;
  const RepositorySource(this.rawValue);

  @override
  String toString() => rawValue;
}

enum ValidUserArguments with ParseableEnum {
  u('-u'),
  find('--find'),
  list('--list'),
  del('--del'),
  delAll('--del-all'),
  up('--up');

  @override
  final String rawValue;
  const ValidUserArguments(this.rawValue);

  @override
  String toString() => rawValue;
}

enum StorageType with ParseableEnum {
  line,
  json,
  binary,
  all;

  @override
  String get rawValue => name;

  @override
  String toString() => name;

  String capitalize() => name[0].toUpperCase() + name.substring(1);
}

extension EnumParsing<E extends Enum> on Iterable<E> {
  E fromString(String input) {
    return firstWhere(
      (e) {
        if (e is ParseableEnum) {
          return (e as ParseableEnum).rawValue.toLowerCase() ==
              input.toLowerCase();
        }
        return e.name.toLowerCase() == input.toLowerCase();
      },
      orElse: () => throw InvalidArgumentException(
        'Valid values are: ${map((e) => e.toString()).join(', ')}',
      ),
    );
  }
}
