import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hard_localization/typedef.dart';
import 'asset_loader.dart';
import 'extensions/index.dart';
import 'exceptions/lang_not_found.dart';
import 'localization.dart';
import 'not_found_key/typedef.dart';
import 'translator.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

class LocalizationController extends ChangeNotifier {
  static final Map<Locale, Translator> _translators = {};

  static List<Locale> _supportedLocales = [];

  final Locale? _fallbackLocale;

  final OnNotFoundCallback? _onNotFoundKey;

  static Locale? _deviceLocale;

  late final OnSave? _onSave;

  static Locale? _savedLocale;

  late Locale _locale;

  Locale get locale => _locale;

  Locale get deviceLocale => _deviceLocale!;

  static List<Locale> get supportedLocales => _supportedLocales;

  LocalizationController({
    Locale? fallbackLocale,
    OnSave? onSave,
    OnNotFoundCallback? onNotFoundKey,
  })  : _fallbackLocale = fallbackLocale,
        _onNotFoundKey = onNotFoundKey,
        _onSave = onSave {
    _locale = _getLocaleOrFallback(_savedLocale ?? _deviceLocale);

    Intl.defaultLocale = _locale.languageCode;
  }

  static bool isSupported(Locale? locale) => _supportedLocales.contains(locale);

  Locale _getLocaleOrFallback(Locale? locale) {
    if (isSupported(locale)) {
      return locale!;
    }

    return _fallbackLocale ?? _supportedLocales.first;
  }

  static Future<void> initialize({
    required AssetLoader assetLoader,
    required GetSavedLocale getSavedLocale,
  }) async {
    assetLoader.mapLocales.forEach((key, value) {
      _translators.addAll({key.toLocale(): Translator(value)});
    });

    _supportedLocales = _translators.keys.toList();

    _deviceLocale = (await findSystemLocale()).toLocale();

    _savedLocale = await getSavedLocale();
  }

  Localization load(Locale locale) {
    return Localization.load(
      currantLocale: locale,
      translators: _translators,
      onNotFoundKey: _onNotFoundKey,
    );
  }

  void setLocale(Locale locale) async {
    if (!isSupported(locale)) {
      throw LangNotFound(locale);
    }

    _locale = locale;

    notifyListeners();

    if (_onSave != null) {
      await _onSave(locale);
    }
  }
}
