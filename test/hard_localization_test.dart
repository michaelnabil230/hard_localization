import 'package:hard_localization/hard_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_asset_loaders.dart';

void main() {
  late LocalizationController controller;

  setUpAll(() {
    LocalizationController.initialize(
      assetLoader: const JsonAssetLoader(),
      getSavedLocale: () => null,
    );

    controller = LocalizationController();
    controller.load(const Locale('en'));
  });

  test('is a localization object', () {
    expect(Localization.instance, isInstanceOf<Localization>());
  });

  test('is a singleton', () {
    expect(Localization.instance, Localization.instance);
  });

  test('is a localization object', () {
    expect(Localization.instance, isInstanceOf<Localization>());
  });

  test('locale from string succeeds', () async {
    expect(const Locale('ar'), 'ar'.toLocale());

    expect(const Locale('ar', 'DZ'), 'ar_DZ'.toLocale());

    expect(
      const Locale.fromSubtags(
        languageCode: 'ar',
        scriptCode: 'Arab',
      ),
      'ar_Arab'.toLocale(),
    );

    expect(
      const Locale.fromSubtags(
        languageCode: 'ar',
        scriptCode: 'Arab',
        countryCode: 'DZ',
      ),
      'ar_Arab_DZ'.toLocale(),
    );
  });

  // test('load correctly locale name', () async {
  //   await LocalizationController.initialize(
  //     assetLoader: const JsonAssetLoader(),
  //     getSavedLocale: () => const Locale('en'),
  //   );

  //   final controller = LocalizationController();

  //   expect(
  //     controller.load(const Locale('ar')),
  //     isInstanceOf<Localization>(),
  //   );

  //   expect(tr('locale'), 'ar');
  // });

  test('controller loads saved locale', () async {
    await LocalizationController.initialize(
      assetLoader: const JsonAssetLoader(),
      getSavedLocale: () => const Locale('en'),
    );

    final controller = LocalizationController(
      fallbackLocale: const Locale('ar'),
    );

    expect(controller.locale, const Locale('en'));
  });

  test('controller loads fallback if saved locale is not supported', () async {
    await LocalizationController.initialize(
      assetLoader: const JsonAssetLoader(),
      getSavedLocale: () => const Locale('fb'),
    );

    final controller = LocalizationController(
      fallbackLocale: const Locale('fb'),
    );

    expect(controller.locale, const Locale('fb'));
  });

  group('locale', () {
    test('locale supports device locale', () {
      const enUS = Locale('en', 'US');

      const en = Locale('en');
      expect(en.supports(enUS), isTrue);

      const en2 = Locale('en', '');
      expect(en2.supports(enUS), isTrue);

      expect(enUS.supports(enUS), isTrue);

      const enGB = Locale('en', 'GB');
      expect(enGB.supports(enUS), isFalse);

      const zhHansCN = Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hans',
        countryCode: 'CN',
      );

      const zh = Locale('zh', '');
      expect(zh.supports(zhHansCN), isTrue);

      const zh2 = Locale('zh', '');
      expect(zh2.supports(zhHansCN), isTrue);

      const zhCN = Locale('zh', 'CN');
      expect(zhCN.supports(zhHansCN), isTrue);

      const zhHans = Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hans',
      );
      expect(zhHans.supports(zhHansCN), isTrue);

      const zhHant = Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hant',
      );
      expect(zhHant.supports(zhHansCN), isFalse);
      expect(zhHansCN.supports(zhHansCN), isTrue);
    });
  });

  group('tr', () {
    test('finds and returns resource', () {
      expect(tr('test'), 'test');
    });

    test('can resolve resource in any nest level', () {
      expect(tr('nested.super.duper.nested'), 'nested.super.duper.nested');
    });

    test('can resolve resource that has a key with dots', () {
      expect(tr('nested.but.not.nested'), 'nested but not nested');
    });

    test('won\'t fail for missing key (no periods)', () {
      expect(tr('Processing'), 'Processing');
    });

    test('won\'t fail for missing key with periods', () {
      expect(tr('Processing.'), 'Processing.');
    });

    test('returns missing resource as provided', () {
      expect(tr('test_missing'), 'test_missing');
    });

    test('returns resource and replaces argument', () {
      expect(
        tr('test_replace_one', args: ['one']),
        'test replace one',
      );
    });
    test('returns resource and replaces argument in any nest level', () {
      expect(
        tr('nested.super.duper.nested_with_arg', args: ['what a nest']),
        'nested.super.duper.nested_with_arg what a nest',
      );
    });

    test('returns resource and replaces argument sequentially', () {
      expect(
        tr('test_replace_two', args: ['one', 'two']),
        'test replace one two',
      );
    });

    test('return resource and replaces named argument', () {
      expect(
        tr('test_replace_named', namedArgs: {'arg1': 'one', 'arg2': 'two'}),
        'test named replace one two',
      );
    });

    test('returns resource and replaces named argument in any nest level', () {
      expect(
        tr('nested.super.duper.nested_with_named_arg',
            namedArgs: {'arg': 'what a nest'}),
        'nested.super.duper.nested_with_named_arg what a nest',
      );
    });
  });
}
