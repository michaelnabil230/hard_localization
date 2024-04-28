import 'package:hard_localization/hard_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils Locales', () {
    group('localeFromString', () {
      test('only language code', () {
        expect('en'.toLocale(), const Locale('en'));
      });

      test('language code and country code', () {
        expect('en_US'.toLocale(), const Locale('en', 'US'));
      });

      test('language code and script code', () {
        expect(
          'zh_Hant'.toLocale(),
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        );
      });

      test('language, country, script code', () {
        expect(
          'zh_Hant_HK'.toLocale(),
          const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK',
          ),
        );
      });
    });

    group('localeToString', () {
      test('test', () {
        Locale locale = const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'HK',
        );
        expect(locale.toStringWithSeparator(), 'zh_Hant_HK');
      });

      test('custom separator', () {
        Locale locale = const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'HK',
        );
        expect(locale.toStringWithSeparator(separator: '|'), 'zh|Hant|HK');
      });
    });
  });
}
