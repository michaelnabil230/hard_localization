import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hard_localization/hard_localization.dart';

import 'utils/test_asset_loaders.dart';

void main() {
  late LocalizationController localizationController;

  group('language-specific-plurals', () {
    setUpAll(() async {
      await LocalizationController.initialize(
        assetLoader: const JsonAssetLoader(),
        getSavedLocale: () => null,
      );

      localizationController = LocalizationController();
    });

    test('english one', () {
      localizationController.load(const Locale('en'));

      expect(plural('hat', 1), 'one hat');
    });

    test('english other', () {
      localizationController.load(const Locale('en'));

      expect(plural('hat', 2), 'other hats');
      expect(plural('hat', 0), 'other hats');
      expect(plural('hat', 3), 'other hats');
    });

    test('arabic one', () {
      localizationController.load(const Locale('ar'));

      expect(plural('hat', 1), 'قبعة واحدة');
    });

    test('arabic other', () {
      localizationController.load(const Locale('ar'));

      expect(plural('hat', 2), 'قبعتان');
      expect(plural('hat', 0), 'لا يوجد قبعات');
      expect(plural('hat', 3), '3 قبعات');
    });
  });
}
