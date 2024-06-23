import 'package:flutter/material.dart';
import 'package:hard_localization/transition.dart' as transition;

extension StringX on String {
  String toPascalCase() {
    if (isEmpty) return '';

    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String tr({
    BuildContext? context,
    List<String>? args,
    Map<String, String>? namedArgs,
    Locale? locale,
  }) =>
      transition.tr(
        this,
        context: context,
        args: args,
        namedArgs: namedArgs,
        locale: locale,
      );

  Locale toLocale({String separator = '_'}) {
    List<String> localeList = split(separator);

    return switch (localeList.length) {
      2 => localeList.last.length == 4
          ? Locale.fromSubtags(
              languageCode: localeList.first,
              scriptCode: localeList.last,
            )
          : Locale(localeList.first, localeList.last),
      3 => Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last,
        ),
      _ => Locale(localeList.first),
    };
  }
}
