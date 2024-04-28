import 'package:flutter/material.dart';

extension LocaleX on Locale {
  bool supports(Locale locale) {
    if (this == locale) {
      return true;
    }

    if (languageCode != locale.languageCode) {
      return false;
    }

    if (countryCode != null &&
        countryCode!.isNotEmpty &&
        countryCode != locale.countryCode) {
      return false;
    }

    if (scriptCode != null && scriptCode != locale.scriptCode) {
      return false;
    }

    return true;
  }

  String toStringWithSeparator({String separator = '_'}) {
    return toString().split('_').join(separator);
  }
}
