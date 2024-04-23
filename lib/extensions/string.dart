import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/public/tr.dart' as transition;
import '/public/plural.dart' as transition_plural;

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

  String plural(
    num value, {
    BuildContext? context,
    List<String>? args,
    Map<String, String>? namedArgs,
    Locale? locale,
    String? name,
    NumberFormat? format,
  }) =>
      transition_plural.plural(
        this,
        value,
        context: context,
        args: args,
        namedArgs: namedArgs,
        locale: locale,
        name: name,
        format: format,
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
