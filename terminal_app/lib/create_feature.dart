import 'dart:io';

import 'package:terminal_app/constants.dart';
import 'package:terminal_app/sample_structure.dart';

Future<void> createFeature(
  String feature, {
  Map<String, dynamic>? sample,
}) async {
  final basePath =
      '${Directory.current.path}${pathSeparator}bin${pathSeparator}src${pathSeparator}features$pathSeparator$feature';
  final structure = sample ?? sampleDicrectoryStructure(feature);
  await createStructure(basePath, structure);
}

Future<void> createStructure(
  String basePath,
  Map<String, dynamic> structure,
) async {
  for (final entry in structure.entries) {
    final name = entry.key;
    final value = entry.value;

    final entityPath = '$basePath$pathSeparator$name';

    try {
      if (value == null) {
        createFile(entityPath);
      } else {
        createDirectory(entityPath);
        createStructure(entityPath, value as Map<String, dynamic>);
      }
    } catch (e, stack) {
      print('🚨 Feature generation failed: $e');
      print(stack);
      exit(1);
    }
  }
}

Future<Directory> createDirectory(String path) async {
  final directory = Directory(path);
  try {
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  } on FileSystemException catch (e, stack) {
    throw Exception(
      '[FileSystemException] Creating directory failed\n'
      'Path: $path\nMessage: ${e.message}\n${e.path}\nStack: $stack',
    );
  } on IOException catch (e, stack) {
    throw Exception(
      '[IOException] General I/O error while creating directory\n'
      'Path: $path\nError: $e\nStack: $stack',
    );
  } catch (e, stack) {
    throw Exception(
      '[Unknown Exception] Creating directory failed\n'
      'Path: $path\nError: $e\nStack: $stack',
    );
  }
}

Future<File> createFile(String path) async {
  final file = File(path);
  try {
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await writeDataToFile(file);
    return file;
  } on FileSystemException catch (e, stack) {
    throw Exception(
      '[FileSystemException] Creating file failed\n'
      'Path: $path\nMessage: ${e.message}\n${e.path}\nStack: $stack',
    );
  } on IOException catch (e, stack) {
    throw Exception(
      '[IOException] General I/O error while creating file\n'
      'Path: $path\nError: $e\nStack: $stack',
    );
  } catch (e, stack) {
    throw Exception(
      '[Unknown Exception] Creating file failed\n'
      'Path: $path\nError: $e\nStack: $stack',
    );
  }
}

Future<File> writeDataToFile(File file) async {
  final className = getClassName(file.path);
  try {
    final templateFile = File('template.txt');
    if (!await templateFile.exists()) {
      throw FileSystemException('Template file not found', templateFile.path);
    }

    final template = await templateFile.readAsString();
    if (!template.contains('{{className}}')) {
      throw FormatException('Template missing placeholder {{className}}');
    }

    final data = template.replaceAll('{{className}}', className);
    await file.writeAsString(data);
    return file;
  } on FileSystemException catch (e, stack) {
    throw Exception(
      '[FileSystemException] Writing file failed for class $className\n'
      'File: ${file.path}\nMessage: ${e.message}\n${e.path}\nStack: $stack',
    );
  } on FormatException catch (e, stack) {
    throw Exception(
      '[FormatException] Invalid template for class $className\n'
      'Message: ${e.message}\nStack: $stack',
    );
  } on IOException catch (e, stack) {
    throw Exception(
      '[IOException] General I/O error writing file for $className\n'
      'File: ${file.path}\nError: $e\nStack: $stack',
    );
  } catch (e, stack) {
    throw Exception(
      '[Unknown Exception] Writing file failed for $className\n'
      'File: ${file.path}\nError: $e\nStack: $stack',
    );
  }
}

String getClassName(String path) {
  return path
      .split(pathSeparator)
      .last
      .split('.')
      .first
      .split('_')
      .map((part) => part.capitalize())
      .join();
}

extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
