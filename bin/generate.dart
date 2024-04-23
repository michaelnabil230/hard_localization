import 'dart:io';

import 'package:args/args.dart';

import 'formatter.dart';

ArgResults _argumentsResults(List<String> arguments) {
  final ArgParser argParser = ArgParser()
    ..addOption(
      'input',
      abbr: 'i',
      defaultsTo: 'translations',
      help: 'The input path of files',
    )
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'lib/generated',
      help: 'Output of generated file',
    )
    ..addOption(
      'format',
      abbr: 'f',
      defaultsTo: FormatTypes.json.name,
      help: 'Support json or keys formats',
      allowed: FormatTypes.toListString(),
    );

  return argParser.parse(arguments);
}

void main(List<String> arguments) {
  final ArgResults argumentsParser = _argumentsResults(arguments);

  FormatTypes.fromString(argumentsParser['format'])
      .toFormatter()
      .format(argumentsParser['input'])
      .then((formatter) => formatter.createFile(argumentsParser['output']))
      .then((path) => Process.run('dart', ['format', path]));
}
