import 'dart:io';

import 'package:terminal_app/constants.dart';
import 'package:terminal_app/create_feature.dart';
import 'package:terminal_app/read_directory_structure.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('No Feature is specified.');
    exit(-1);
  }
  if (arguments.first != '-f') {
    print('Before Declaring Feature should use \'-f\'.');
    exit(-1);
  }
  if (arguments.length == 1) {
    print('Please Specify the Feature(s).');
    exit(-1);
  }
  final indexPathFlag = arguments.indexWhere((arg) => arg == '-p');
  final indexPath = arguments.indexWhere((arg) => arg.contains(pathSeparator));

  if (indexPath == -1 && indexPathFlag == -1) {
    for (var i = 1; i < arguments.length; i++) {
      createFeature(arguments[i]);
    }
  } else if (indexPathFlag != -1 && indexPath == -1) {
    print('Please specify the path of the sample directory');
    exit(-1);
  } else if (indexPathFlag == -1 && indexPath != -1) {
    print('Use \'-p\' flag before specifying path of the sample directory');
    exit(-1);
  } else {
    final features = arguments.sublist(1, indexPathFlag);
    final directory = Directory(arguments[indexPath]);
    if (!directory.existsSync()) {
      print('No Such Directory Found!');
      exit(-1);
    }
    final structure = await readDirectoryStrcture(directory);

    for (final feature in features) {
      createFeature(feature, sample: structure);
    }
  }
}
