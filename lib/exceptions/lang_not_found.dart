import 'package:flutter/material.dart';

class LangNotFound implements Exception {
  final Locale? locale;

  LangNotFound(this.locale);

  @override
  String toString() {
    if (locale == null) {
      return 'The locale is not supported on the app';
    }

    return 'The locale is not supported by the app: ${locale.toString()}';
  }
}
