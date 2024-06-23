import 'package:flutter/material.dart';
import '/localization.dart';

String tr(
  String key, {
  BuildContext? context,
  List<String>? args,
  Map<String, String>? namedArgs,
  Locale? locale,
}) {
  return context != null
      ? Localization.of(context).translate(
          key,
          args: args,
          namedArgs: namedArgs,
          locale: locale,
        )
      : Localization.instance.translate(
          key,
          args: args,
          namedArgs: namedArgs,
          locale: locale,
        );
}
