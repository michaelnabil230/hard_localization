import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/public/tr.dart' as transition;
import '/public/plural.dart' as transition_plural;

extension TextTranslateExtension on Text {
  /// {@macro tr}
  Text tr({
    List<String>? args,
    BuildContext? context,
    Map<String, String>? namedArgs,
  }) =>
      Text(
        transition.tr(
          data ?? '',
          context: context,
          args: args,
          namedArgs: namedArgs,
        ),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
      );

  /// {@macro plural}
  Text plural(
    num value, {
    BuildContext? context,
    List<String>? args,
    Map<String, String>? namedArgs,
    String? name,
    NumberFormat? format,
  }) =>
      Text(
        transition_plural.plural(
          data ?? '',
          value,
          context: context,
          args: args,
          namedArgs: namedArgs,
          name: name,
          format: format,
        ),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
      );
}
