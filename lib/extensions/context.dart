import 'package:flutter/material.dart';
import '/controller.dart';
import '/set_up_localization.dart';

extension LangX on BuildContext {
  LocalizationController get _controller =>
      SetUpLocalization.of(this)!.controller;

  List<LocalizationsDelegate> get delegates =>
      SetUpLocalization.of(this)!.delegates;

  List<Locale> get supportedLocales => LocalizationController.supportedLocales;

  void setLocale(Locale locale) => _controller.setLocale(locale);

  Locale get locale => _controller.locale;

  Locale get deviceLocale => _controller.deviceLocale;

  String get languageCode => locale.languageCode;

  bool get isArabic => languageCode.toLowerCase() == 'ar';

  bool get isEnglish => languageCode.toLowerCase() == 'en';
}
