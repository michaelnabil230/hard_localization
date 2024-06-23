import 'dart:developer';
import 'dart:io';

import 'package:hard_localization/exceptions/lang_not_found.dart';
import 'package:hard_localization/hard_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hard_localization/set_up_localization.dart';
import 'utils/test_asset_loaders.dart';

late BuildContext _context;

late String _contextTranslationValue;

class MyApp extends StatelessWidget {
  final Widget child;

  const MyApp({
    super.key,
    this.child = const MyWidget(),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.delegates,
      home: child,
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
        ],
      ),
    );
  }
}

class MyLocalizedWidget extends StatelessWidget {
  const MyLocalizedWidget({super.key});

  @override
  Widget build(context) {
    _context = context;
    _contextTranslationValue = context.tr('test');

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(_contextTranslationValue),
        ],
      ),
    );
  }
}

Future<void> _initialization() async {
  await LocalizationController.initialize(
    assetLoader: const JsonAssetLoader(),
    getSavedLocale: () => null,
  );
}

void main() async {
  testWidgets('[HardLocalization with JsonAssetLoader] test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) => log('On Save'),
        child: const MyApp(),
      ));

      await tester.pump();

      expect(Localization.of(_context), isInstanceOf<Localization>());
      expect(Localization.instance, isInstanceOf<Localization>());
      expect(Localization.instance, Localization.of(_context));

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);
      expect(_context.locale, const Locale('en'));

      final trFinder = find.text('test');
      expect(trFinder, findsOneWidget);

      expect(tr('test'), 'test');

      expect('test'.tr(), 'test');
    });
  });

  testWidgets('[HardLocalization] change locale test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);
      expect(_context.locale, const Locale('en'));

      _context.setLocale(const Locale('en'));
      await tester.pump();
      expect(_context.locale, const Locale('en'));

      final trFinder = find.text('test');
      expect(trFinder, findsOneWidget);

      expect(tr('test'), 'test');
      expect(_context.locale, const Locale('en'));

      expect(() => _context.setLocale(const Locale('ar', 'EG')),
          throwsA(isA<LangNotFound>()));
      await tester.pump();

      expect(_context.locale, const Locale('en'));
    });
  });

  testWidgets('[HardLocalization] locale ar test', (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      _context.setLocale(const Locale('ar'));

      await tester.pump();

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);

      expect(_context.locale, const Locale('ar'));

      var trFinder = find.text('اختبار');
      expect(trFinder, findsOneWidget);

      expect(Localization.of(_context), isInstanceOf<Localization>());
      expect(tr('test'), 'اختبار');
    });
  });

  testWidgets('[HardLocalization] fallbackLocale with doesn\'t saveLocale test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);

      expect(_context.locale, const Locale('en'));

      var l = const Locale('en');
      _context.setLocale(l);
      expect(_context.locale, l);
    });
  });

  testWidgets('[HardLocalization] fallbackLocale not equal null test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        fallbackLocale: const Locale('ar'),
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

  testWidgets('[HardLocalization] fallbackLocale equal null test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.supportedLocales, [
        const Locale('en'),
        const Locale('ar'),
      ]);

      expect(_context.locale, const Locale('en'));
    });
  });

  testWidgets('[HardLocalization] device locale test',
      (WidgetTester tester) async {
    await _initialization();

    await tester.runAsync(() async {
      await tester.pumpWidget(SetUpLocalization(
        onSave: (locale) {},
        child: const MyApp(),
      ));

      await tester.pump();

      expect(_context.deviceLocale.toString(), Platform.localeName);
    });
  });

  group('Context extensions tests', () {
    testWidgets(
      '[HardLocalization] Throws LangNotFound test',
      (WidgetTester tester) async {
        await _initialization();

        await tester.pumpWidget(SetUpLocalization(
          onSave: (locale) {},
          child: const MyApp(child: MyLocalizedWidget()),
        ));

        await tester.pumpAndSettle();

        expect(
            () => _context.setLocale(const Locale('fr')),
            throwsA(const TypeMatcher<LangNotFound>()
                .having((e) => e.locale, 'locale', const Locale('fr'))));
      },
    );

    testWidgets(
        '[HardLocalization] context.translate and context.plural text widgets are in the tree',
        (WidgetTester tester) async {
      await _initialization();

      await tester.runAsync(() async {
        await tester.pumpWidget(SetUpLocalization(
          onSave: (locale) {},
          child: const MyApp(child: MyLocalizedWidget()),
        ));

        await tester.idle();
        await tester.pumpAndSettle();

        expect(
          find.text(_contextTranslationValue),
          findsOneWidget,
        );
      });
    });

    testWidgets(
      '[HardLocalization] context.translate and context.plural provide relevant texts',
      (WidgetTester tester) async {
        await _initialization();

        await tester.runAsync(() async {
          await tester.pumpWidget(SetUpLocalization(
            onSave: (locale) {},
            child: const MyApp(child: MyLocalizedWidget()),
          ));

          const expectedEnTranslateTextWidgetValue = 'test';
          const expectedArTranslateTextWidgetValue = 'اختبار';
          const arabyLocale = Locale('ar');

          await tester.idle();

          await tester.pumpAndSettle();

          expect(
            _contextTranslationValue == expectedEnTranslateTextWidgetValue,
            true,
          );

          _context.setLocale(arabyLocale);

          await tester.pumpAndSettle();

          expect(
            _contextTranslationValue == expectedArTranslateTextWidgetValue,
            true,
          );
        });
      },
    );
  });
}
