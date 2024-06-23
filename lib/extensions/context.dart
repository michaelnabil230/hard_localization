import 'package:flutter/material.dart';
import 'package:hard_localization/hard_localization.dart';
import '/set_up_localization.dart';

extension LangX on BuildContext {
  LocalizationController get _controller =>
      SetUpLocalization.of(this)!.controller;

  List<LocalizationsDelegate> get delegates =>
      SetUpLocalization.of(this)!.delegates;

  List<Locale> get supportedLocales => LocalizationController.supportedLocales;

  void setLocale(Locale locale) => _controller.setLocale(locale);

  Locale get locale => _controller.locale;

  String get languageCode => locale.languageCode;

  Locale get deviceLocale => _controller.deviceLocale;

  String get deviceLanguageCode => deviceLocale.languageCode;

  String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    Locale? locale,
  }) =>
      key.tr(
        args: args,
        context: this,
        locale: locale,
        namedArgs: namedArgs,
      );
}
