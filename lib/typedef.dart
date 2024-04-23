import 'dart:async';

import 'package:flutter/material.dart' show Locale;

typedef OnSave = FutureOr<void> Function(Locale locale);

typedef GetSavedLocale = FutureOr<Locale?> Function();
