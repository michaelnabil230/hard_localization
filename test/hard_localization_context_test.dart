import 'dart:developer';
import 'dart:io';

import 'package:hard_localization/hard_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hard_localization/set_up_localization.dart';

import 'utils/test_asset_loaders.dart';

late BuildContext _context;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.delegates,
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(context) {
    _context = context;
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Text('test').tr(),
          const Text('day').plural(1),
        ],
      ),
    );
  }
}

void main() async {
  await LocalizationController.initialize(
    assetLoader: const JsonAssetLoader(),
    getSavedLocale: () => null,
  );

  testWidgets('[HardLocalization] fallback locale is not equal null test',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        fallbackLocale: const Locale('ar'),
        onSave: (Locale locale) => log('On Save'),
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);

      expect(_context.locale, const Locale('ar'));
    });
  });

  testWidgets('[HardLocalization] fallback locale is equal null test',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) => log('On Save'),
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.locale, const Locale('en'));
    });
  });

  testWidgets('[HardLocalization] device locale test',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.deviceLocale.toString(), Platform.localeName);
    });
  });
}
