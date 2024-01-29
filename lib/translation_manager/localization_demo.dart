import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationDemo {
  final Locale locale;
  LocalizationDemo(this.locale);

  static LocalizationDemo? of(BuildContext context) {
    return Localizations.of<LocalizationDemo>(context, LocalizationDemo);
  }

  static Map<String, String>? _localizedValues;
  load() async {
    String jsonValues = await rootBundle
        .loadString('assets/locales/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValue(String key) {
    return _localizedValues![key];
  }

  static DemoLocalizationsDelegate delegate = const DemoLocalizationsDelegate();
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<LocalizationDemo> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'ur',
      'hi',
      'ar',
      'id',
      'bn',
      'de',
      'zh',
      'it',
      'ja',
      'ko',
      'fa',
      'pl',
      'pt',
      'ru',
      'es',
      'sv',
      'ta',
      'th',
      'tr',
      'uk',
      'vi',
      'fr',
      'nl'
    ].contains(locale.languageCode);
  }

  @override
  Future<LocalizationDemo> load(Locale locale) async {
    LocalizationDemo localizationDemo = LocalizationDemo(locale);
    await localizationDemo.load();
    return localizationDemo;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
