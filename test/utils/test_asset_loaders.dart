import 'dart:ui';

import 'package:hard_localization/asset_loader.dart';

class JsonAssetLoader extends AssetLoader {
  const JsonAssetLoader();

  @override
  Map<String, dynamic>? load(Locale locale) {
    return mapLocales[locale.toString()];
  }

  static const Map<String, dynamic> en = {
    'locale': 'en',
    'test': 'test',
    'test_replace_one': 'test replace {}',
    'test_replace_two': 'test replace {} {}',
    'test_replace_named': 'test named replace {arg1} {arg2}',
    'nested.but.not.nested': 'nested but not nested',
    'nested': {
      'super': {
        'duper': {
          'nested': 'nested.super.duper.nested',
          'nested_with_arg': 'nested.super.duper.nested_with_arg {}',
          'nested_with_named_arg':
              'nested.super.duper.nested_with_named_arg {arg}'
        }
      }
    },
    'test_fallback_plurals': {
      'one': '{} second',
      'other': '{} seconds',
    },
  };

  static const Map<String, dynamic> ar = {
    'locale': 'ar',
    'test': 'اختبار',
    'test_replace_one': 'اختبار استبدال {}',
    'test_replace_two': 'اختبار استبدال {} {}',
    'test_replace_named': 'اختبار الاستبدال المسمى {arg1} {arg2}',
    'nested.but.not.nested': 'متداخل ولكن ليس متداخلًا',
    'nested': {
      'super': {
        'duper': {
          'nested': 'متداخل.متفوق.متداخل',
          'nested_with_arg': 'متداخل.متفوق.متداخل_مع_الوسيط {}',
          'nested_with_named_arg': 'متداخل.متفوق.متداخل_مع_الوسيط_المسمى {arg}'
        }
      }
    },
    'test_fallback_plurals': {
      'one': '{} ثانية',
      'other': '{} ثواني',
    },
  };

  @override
  Map<String, Map<String, dynamic>> get mapLocales => {'en': en, 'ar': ar};
}
