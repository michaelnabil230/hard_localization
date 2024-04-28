import 'extensions/index.dart';
import 'plural_rules.dart';
import 'package:intl/intl.dart';

class Translator {
  final Map<String, dynamic> _data;

  final Map<String, dynamic> _nestedKeysCache = {};

  Map<String, dynamic> get data => _data;

  Translator(this._data);

  String translate({
    required String key,
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    String result = _get(key);

    result = _replaceArgs(result: result, args: args);

    return _replaceNamedArgs(result: result, namedArgs: namedArgs);
  }

  String plural(
    String key,
    num value,
    String languageCode, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? name,
    NumberFormat? format,
  }) {
    final pluralRule = _pluralRule(languageCode, value);

    final PluralCase pluralCase =
        pluralRule != null ? pluralRule() : _pluralCaseFallback(value);

    final String formattedValue =
        format == null ? '$value' : format.format(value);

    if (name != null) {
      namedArgs = {...?namedArgs, name: formattedValue};
    }

    return switch (pluralCase) {
      PluralCase.ZERO => translate(
          key: '$key.zero',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.ONE => translate(
          key: '$key.one',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.TWO => translate(
          key: '$key.two',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.FEW => translate(
          key: '$key.few',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.MANY => translate(
          key: '$key.many',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.OTHER => translate(
          key: '$key.other',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
    };
  }

  String _get(String key) {
    if (_isNestedKey(key)) {
      return _getNested(key) ?? key;
    }

    return _data[key] ?? key;
  }

  String? _getNested(String key) {
    if (_isNestedCached(key)) return _nestedKeysCache[key];

    final keys = key.split('.');
    final kHead = keys.first;

    var value = _data[kHead];

    for (int i = 1; i < keys.length; i++) {
      if (value is Map<String, dynamic>) value = value[keys[i]];
    }

    if (value != null) {
      _cacheNestedKey(key, value);
    }

    return value;
  }

  bool _isNestedCached(String key) => _nestedKeysCache.containsKey(key);

  void _cacheNestedKey(String key, String value) {
    if (!_isNestedKey(key)) {
      return;
    }

    _nestedKeysCache[key] = value;
  }

  bool _isNestedKey(String key) => !_data.containsKey(key) && key.contains('.');

  String _replaceArgs({required String result, required List<String>? args}) {
    if (args == null || args.isEmpty) return result;

    for (String str in args) {
      result = result.replaceFirst(RegExp('{}'), str);
    }

    return result;
  }

  String _replaceNamedArgs({
    required String result,
    required Map<String, String>? namedArgs,
  }) {
    if (namedArgs == null || namedArgs.isEmpty) return result;

    namedArgs.forEach((String key, String value) {
      result = result
          .replaceAll(RegExp('{$key}'), value)
          .replaceAll(RegExp('{${key.toUpperCase()}}'), value.toUpperCase())
          .replaceAll(RegExp('{${key.toLowerCase()}}'), value.toLowerCase())
          .replaceAll(RegExp('{${key.toPascalCase()}}'), value.toPascalCase());
    });

    return result;
  }

  PluralRule? _pluralRule(String languageCode, num howMany) {
    startRuleEvaluation(howMany);
    return pluralRules[languageCode];
  }

  PluralCase _pluralCaseFallback(num value) {
    return switch (value) {
      0 => PluralCase.ZERO,
      1 => PluralCase.ONE,
      2 => PluralCase.TWO,
      _ => PluralCase.OTHER,
    };
  }
}
