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
    'day': {
      'zero': '{} days',
      'one': '{} day',
      'two': '{} days',
      'few': '{} few days',
      'many': '{} many days',
      'other': '{} other days'
    },
    'hat': {
      'zero': 'no hats',
      'one': 'one hat',
      'two': 'two hats',
      'few': 'few hats',
      'many': 'many hats',
      'other': 'other hats'
    },
    'hat_other': {'other': 'other hats'},
    'money': {
      'zero': '{} has no money',
      'one': '{} has {} dollar',
      'other': '{} has {} dollars',
    },
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
    'day': {
      'zero': '{} أيام',
      'one': '{} يوم',
      'two': '{} أيام',
      'few': '{} أيام',
      'many': '{} أيام',
      'other': '{} أيام'
    },
    'hat': {
      'zero': 'لا يوجد قبعات',
      'one': 'قبعة واحدة',
      'two': 'قبعتان',
      'few': '{} قبعات',
      'many': '{} قبعة',
      'other': '{} قبعة أخرى'
    },
    'hat_other': {'other': '{} قبعة أخرى'},
    'money': {
      'zero': '{} ليس لديه مال',
      'one': '{} لديه {} دولار',
      'other': '{} لديه {} دولارات',
    },
    'money_named_args': {
      'zero': '{name} ليس لديه مال',
      'one': '{name} لديه {money} دولار',
      'other': '{name} لديه {money} دولارات',
    },
    'nested_periods': {
      'Processing': 'معالجة',
      'Processing.': 'معالجة.',
    },
    'nested.but.not.nested': 'متداخل ولكن ليس متداخلًا',
    'modified': 'معدل',
    'many': 'كثير',
    'messages': 'رسائل',
    'brackets': 'أقواس',
    'nestedArg': 'متداخل {}{}',
    'nestedNamedArg': 'متداخل {secondArg}{thirdArg}',
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
