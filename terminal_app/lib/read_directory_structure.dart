import 'dart:io';

import 'package:terminal_app/constants.dart';

Future<Map<String, dynamic>> readDirectoryStrcture(Directory directory) async {
  final structure = <String, dynamic>{};
  final list = directory.list();

  await for (final entity in list) {
    final name = entity.path.split(pathSeparator).last;

    if (name.startsWith('.')) continue;

    if (entity is File) {
      structure[name] = null;
    } else if (entity is Directory) {
      final value = await readDirectoryStrcture(entity);
      structure[name] = value;
    }
  }

  return structure;
}
