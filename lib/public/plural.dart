import 'package:flutter/material.dart';
import '/localization.dart';
import 'package:intl/intl.dart';

String plural(
  String key,
  num value, {
  BuildContext? context,
  List<String>? args,
  Map<String, String>? namedArgs,
  Locale? locale,
  String? name,
  NumberFormat? format,
}) {
  return context != null
      ? Localization.of(context).plural(
          key,
          value,
          args: args,
          namedArgs: namedArgs,
          locale: locale,
          name: name,
          format: format,
        )
      : Localization.instance.plural(
          key,
          value,
          args: args,
          namedArgs: namedArgs,
          locale: locale,
          name: name,
          format: format,
        );
}
