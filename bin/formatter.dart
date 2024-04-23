import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

enum FormatTypes {
  json,
  keys;

  static List<String> toListString() => values.map((e) => e.name).toList();

  static FormatTypes fromString(String value) =>
      values.firstWhere((element) => element.name == value);

  Format toFormatter() => switch (this) {
        FormatTypes.json => JsonFormat(),
        FormatTypes.keys => JsonFormat(),
      };
}

abstract class Format {
  String get _filePrefix;

  String? file;

  Future<Format> format(String input);

  String createFile(String output) {
    final String path = '$output/translations_$_filePrefix.dart';

    final File generatedFile = File(path);

    if (!generatedFile.existsSync()) {
      generatedFile.createSync(recursive: true);
    }

    if (file == null) {
      throw Exception('The file is empty');
    }

    generatedFile.writeAsStringSync(file!);

    stdout.writeln('Dart code is generated and saved to $path');

    return path;
  }
}

class DartFormat extends Format {
  @override
  String get _filePrefix => 'loader_keys';

  @override
  Future<DartFormat> format(String input) async {
    String jsonData = File(input).readAsStringSync();

    file = _buildFile(jsonDecode(jsonData));

    return this;
  }

  String _convertJsonToDartKeys(Map<String, dynamic> json,
      [String prefix = '']) {
    StringBuffer buffer = StringBuffer();

    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        String constantName = prefix.isEmpty ? key : '${prefix}_$key';

        // If the value is a nested object, add the parent key as a prefix
        buffer.write(_convertJsonToDartKeys(value, constantName));
      } else {
        // If the value is not a nested object, create a constant
        String constantName = prefix.isEmpty ? key : '${prefix}_$key';
        String constantValue = "'${prefix.isEmpty ? key : '$prefix.$key'}'";
        buffer.writeln('  static const $constantName = $constantValue;');
      }
    });

    return buffer.toString();
  }

  String _buildFile(Map<String, dynamic> json) {
    String dartCode = '''
// DO NOT EDIT. This is code generated

// ignore_for_file: constant_identifier_names

abstract class LocaleKeys {
''';

    // Generate Dart code with constants
    dartCode += _convertJsonToDartKeys(json);

    dartCode += '}';

    return dartCode;
  }
}

class JsonFormat extends Format {
  @override
  String get _filePrefix => 'loader';

  @override
  Future<JsonFormat> format(String input) async {
    file = _buildFile(await _getFiles(input));

    return this;
  }

  Future<List<FileSystemEntity>> _getFiles(String input) async {
    final Directory source = Directory.fromUri(Uri.parse(input));
    final Directory sourcePath =
        Directory(path.join(Directory.current.path, source.path));

    if (!await sourcePath.exists()) {
      stdout.writeln('Source path does not exist');
      exit(0);
    }

    List<FileSystemEntity> files = await _dirContents(sourcePath);

    if (files.isEmpty) {
      stdout.writeln('Source path empty');
      exit(0);
    }

    return files;
  }

  String _buildFile(List<FileSystemEntity> files) {
    String dartCode = '''
// DO NOT EDIT. This is code generated

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:flutter_application_2/asset_loader.dart';

class TranslateLoader extends AssetLoader {
  const TranslateLoader();

  @override
  Map<String, dynamic>? load(Locale locale) {
    return mapLocales[locale.toString()];
  }

''';

    final List<String> listLocales = [];

    // Define static constants for each language
    for (final file in files) {
      String language = file.path.split('/').last.split('.').first;
      String jsonData = File(file.path).readAsStringSync();
      dartCode += '''
  static const Map<String, dynamic> $language = $jsonData;

''';

      final String localeName = path
          .basename(file.path)
          .replaceFirst('.json', '')
          .replaceAll('-', '_');

      listLocales.add('"$localeName": $localeName');
    }

    // Implement a getter to provide a map of locales to their respective JSON maps
    dartCode += '''
  @override
  Map<String, Map<String, dynamic>> get mapLocales => {${listLocales.join(', ')}};
}
''';

    return dartCode;
  }

  Future<List<FileSystemEntity>> _dirContents(Directory dir) {
    final files = <FileSystemEntity>[];

    final completer = Completer<List<FileSystemEntity>>();

    dir.list(recursive: false).listen(
          (file) => files.add(file),
          onDone: () => completer.complete(files),
        );

    return completer.future;
  }
}
