import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  static const _localeKey = 'app_locale';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> toggleLocale() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.languageCode == 'en') {
      state = const Locale('ar');
      await prefs.setString(_localeKey, 'ar');
    } else {
      state = const Locale('en');
      await prefs.setString(_localeKey, 'en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    state = locale;
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
