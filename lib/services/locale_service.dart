import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  final SharedPreferences _prefs;
  static const String _localeKey = 'app_locale';

  // Available options
  static const String system = 'system';
  static const String en = 'en';
  static const String nl = 'nl';

  final ValueNotifier<Locale?> currentLocale = ValueNotifier<Locale?>(null);

  LocaleService(this._prefs) {
    _loadLocale();
  }

  void _loadLocale() {
    final String? loadedLocale = _prefs.getString(_localeKey);
    if (loadedLocale == null || loadedLocale == system) {
      currentLocale.value = null; // Follow system
    } else {
      currentLocale.value = Locale(loadedLocale);
    }
  }

  Future<void> updateLocale(String localeCode) async {
    if (localeCode == system) {
      await _prefs.remove(_localeKey);
      currentLocale.value = null;
    } else {
      await _prefs.setString(_localeKey, localeCode);
      currentLocale.value = Locale(localeCode);
    }
  }

  String getSelectedLocaleCode() {
    final String? loadedLocale = _prefs.getString(_localeKey);
    return loadedLocale ?? system;
  }
}
