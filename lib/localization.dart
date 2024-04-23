import 'package:flutter/material.dart';
import 'exceptions/lang_not_found.dart';
import 'not_found_key/typedef.dart';
import 'translator.dart';
import 'package:intl/intl.dart';

class Localization {
  Localization._();

  late Map<Locale, Translator> _translators;

  late Locale _currantLocale;

  late OnNotFoundCallback? _onNotFoundKey;

  static Localization? _instance;

  static Localization get instance => _instance ??= Localization._();

  static Localization of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization)!;

  static Localization load({
    required Locale currantLocale,
    required Map<Locale, Translator> translators,
    required OnNotFoundCallback? onNotFoundKey,
  }) {
    instance._currantLocale = currantLocale;
    instance._translators = translators;
    instance._onNotFoundKey = onNotFoundKey;

    return instance;
  }

  String translate(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    Locale? locale,
  }) {
    String result = _getTranslator(locale).translate(
      key: key,
      args: args,
      namedArgs: namedArgs,
    );

    _onNotFound(result, key);

    return result;
  }

  void _onNotFound(String result, String key) {
    if (result == key && _onNotFoundKey != null) {
      _onNotFoundKey!.call(key);
    }
  }

  String plural(
    String key,
    num value, {
    List<String>? args,
    Map<String, String>? namedArgs,
    Locale? locale,
    String? name,
    NumberFormat? format,
  }) {
    String result = _getTranslator(locale).plural(
      key,
      value,
      _getLocale(locale).languageCode,
      args: args,
      namedArgs: namedArgs,
      name: name,
      format: format,
    );

    _onNotFound(result, key);

    return result;
  }

  Translator _getTranslator([Locale? locale]) {
    final Locale localeAs = _getLocale(locale);

    if (!_translators.containsKey(localeAs)) {
      throw LangNotFound(localeAs);
    }

    return _translators[localeAs]!;
  }

  Locale _getLocale([Locale? locale]) => locale ?? _currantLocale;
}
