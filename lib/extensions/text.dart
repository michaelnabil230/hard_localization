import 'package:flutter/material.dart';
import 'package:hard_localization/transition.dart' as transition;

extension TextTranslateExtension on Text {
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
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
      );
}
