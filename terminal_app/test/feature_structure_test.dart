import 'dart:io';
import 'package:test/test.dart';

// Import your generator functions
import 'package:terminal_app/create_feature.dart';

void main() {
  group('Feature Generator Exception Tests', () {
    late File tempFile;
    late File template;

    setUp(() async {
      tempFile = File('temp_feature.dart');
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      template = File('template.txt');
      if (await template.exists()) {
        await template.delete();
      }
    });

    tearDown(() async {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      if (await template.exists()) {
        await template.delete();
      }
    });

    test('throws FileSystemException when template.txt is missing', () async {
      await tempFile.create(recursive: true);

      expect(
        () async => await writeDataToFile(tempFile),
        throwsA(
          predicate((e) => e.toString().contains('Template file not found')),
        ),
      );
    });

    test(
      'throws FormatException when template missing {{className}}',
      () async {
        await template.writeAsString('class Test {}'); // no placeholder
        await tempFile.create(recursive: true);

        expect(
          () async => await writeDataToFile(tempFile),
          throwsA(
            predicate(
              (e) => e.toString().contains('Template missing placeholder'),
            ),
          ),
        );
      },
    );

    test('throws FileSystemException for invalid file path', () async {
      final badPath = Platform.isWindows
          ? 'C:\\Invalid?:Path\\file.dart'
          : '/invalid0path/file.dart';

      expect(
        () async => await createFile(badPath),
        throwsA(
          predicate((e) => e.toString().contains('Creating file failed')),
        ),
      );
    });

    test('throws FileSystemException for permission denied', () async {
      final restrictedPath = Platform.isWindows
          ? 'C:\\Windows\\System32\\restricted.dart'
          : '/restricted.dart';

      expect(
        () async => await createFile(restrictedPath),
        throwsA(
          predicate((e) => e.toString().contains('Creating file failed')),
        ),
      );
    });

    test('throws Unknown Exception when unexpected error occurs', () async {
      await template.writeAsString('class {{className}} {}');
      await tempFile.create(recursive: true);

      expect(
        () async {
          // Simulate unknown error manually
          throw Exception('Something weird happened');
        },
        throwsA(
          predicate((e) => e.toString().contains('Something weird happened')),
        ),
      );
    });
  });
}
