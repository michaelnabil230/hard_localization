import 'extensions/index.dart';

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
}
