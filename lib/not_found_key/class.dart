import 'package:flutter/material.dart';
import 'typedef.dart';

class OnNotFound {
  final OnNotFoundCallback? callback;

  final Widget Function(String translationKey)? widget;

  const OnNotFound({
    this.callback,
    this.widget,
  });
}
