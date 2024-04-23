import 'extensions/index.dart';
import 'plural_rules.dart';
import 'package:intl/intl.dart';

class Translator {
  final Map<String, dynamic> _translator;

  final Map<String, dynamic> _nestedKeysCache = {};

  Translator(this._translator);

  String translate({
    required String key,
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    String result = _get(key);

    result = _replaceArgs(result, args);

    return _replaceNamedArgs(result, namedArgs);
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
      PluralCase.ZERO => _resolvePlural(
          key: key,
          subKey: 'zero',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.ONE => _resolvePlural(
          key: key,
          subKey: 'one',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.TWO => _resolvePlural(
          key: key,
          subKey: 'two',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.FEW => _resolvePlural(
          key: key,
          subKey: 'few',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.MANY => _resolvePlural(
          key: key,
          subKey: 'many',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
      PluralCase.OTHER => _resolvePlural(
          key: key,
          subKey: 'other',
          args: args ?? [formattedValue],
          namedArgs: namedArgs,
        ),
    };
  }

  String _get(String key) {
    if (_isNestedKey(key)) {
      return _getNested(key) ?? key;
    }

    return _translator[key] ?? key;
  }

  String? _getNested(String key) {
    if (_isNestedCached(key)) return _nestedKeysCache[key];

    final keys = key.split('.');
    final kHead = keys.first;

    var value = _translator[kHead];

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

  bool _isNestedKey(String key) =>
      !_translator.containsKey(key) && key.contains('.');

  String _replaceArgs(String result, List<String>? args) {
    if (args == null || args.isEmpty) return result;

    RegExp replaceArgRegex = RegExp('{}');

    for (String str in args) {
      result = result.replaceFirst(replaceArgRegex, str);
    }

    return result;
  }

  String _replaceNamedArgs(String result, Map<String, String>? args) {
    if (args == null || args.isEmpty) return result;

    args.forEach((String key, String value) {
      result = result
          .replaceAll(RegExp('{$key}'), value)
          .replaceAll(RegExp('{${key.toUpperCase()}}'), value.toUpperCase())
          .replaceAll(RegExp('{${key.toLowerCase()}}'), value.toLowerCase())
          .replaceAll(RegExp('{${key.toPascalCase()}}'), value.toPascalCase());
    });

    return result;
  }

  String _resolvePlural({
    required String key,
    required String subKey,
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    if (subKey == 'other') {
      return translate(
        key: '$key.other',
        args: args,
        namedArgs: namedArgs,
      );
    }

    String tag = '$key.$subKey';

    String resource = translate(
      key: tag,
      args: args,
      namedArgs: namedArgs,
    );

    if (resource == tag) {
      resource = translate(
        key: '$key.other',
        args: args,
        namedArgs: namedArgs,
      );
    }

    return resource;
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
