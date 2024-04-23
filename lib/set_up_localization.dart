import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hard_localization/typedef.dart';
import 'controller.dart';
import 'localization.dart';
import 'not_found_key/class.dart';

class SetUpLocalization extends StatefulWidget {
  final Widget child;

  final Locale? fallbackLocale;

  final OnSave onSave;

  final OnNotFound noNotFound;

  const SetUpLocalization({
    super.key,
    required this.child,
    required this.onSave,
    this.fallbackLocale,
    this.noNotFound = const OnNotFound(),
  });

  static LocalizationProvider? of(BuildContext context) =>
      LocalizationProvider.of(context);

  @override
  State<SetUpLocalization> createState() => _SetUpLocalizationState();
}

class _SetUpLocalizationState extends State<SetUpLocalization> {
  late LocalizationController _localizationController;

  late Widget? _notFoundWidget;

  @override
  void initState() {
    _localizationController = LocalizationController(
      fallbackLocale: widget.fallbackLocale,
      onSave: widget.onSave,
      onNotFoundKey: _onNotFoundKey,
    );

    _localizationController.addListener(() {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  void _onNotFoundKey(String value) {
    final OnNotFound onNotFound = widget.noNotFound;

    final callback = onNotFound.callback;

    if (callback != null) {
      callback.call(value);
    }

    final notFoundWidget = onNotFound.widget;

    if (notFoundWidget != null) {
      _notFoundWidget = notFoundWidget(value);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      controller: _localizationController,
      child: _notFoundWidget ?? widget.child,
    );
  }
}

class LocalizationProvider extends InheritedWidget {
  final LocalizationController controller;

  final Locale? currentLocale;

  List<LocalizationsDelegate> get delegates => [
        LocalizationDelegate.delegate(controller),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  /// Change app locale
  void setLocale(Locale locale) {
    if (locale != controller.locale) {
      controller.setLocale(locale);
    }
  }

  LocalizationProvider({
    super.key,
    required super.child,
    required this.controller,
  }) : currentLocale = controller.locale;

  @override
  bool updateShouldNotify(LocalizationProvider oldWidget) {
    return oldWidget.currentLocale != controller.locale;
  }

  static LocalizationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocalizationProvider>();
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  final LocalizationController localizationController;

  LocalizationDelegate({
    required this.localizationController,
  });

  static LocalizationDelegate delegate(LocalizationController controller) =>
      LocalizationDelegate(localizationController: controller);

  @override
  bool isSupported(Locale locale) => LocalizationController.isSupported(locale);

  @override
  Future<Localization> load(Locale locale) async {
    return localizationController.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
