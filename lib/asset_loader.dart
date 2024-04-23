import 'dart:ui';

abstract class AssetLoader {
  const AssetLoader();

  Map<String, dynamic>? load(Locale locale);

  Map<String, Map<String, dynamic>> get mapLocales;
}
