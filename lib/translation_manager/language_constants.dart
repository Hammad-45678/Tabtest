import 'package:flutter/cupertino.dart';
import 'localization_demo.dart';

String localeText(BuildContext context, String key) {
  final localizationDemo = LocalizationDemo.of(context);

  if (localizationDemo == null) {
    return '';
  }

  final translatedValue = localizationDemo.getTranslatedValue(key);

  if (translatedValue == null) {
    return '';
  }

  return translatedValue;
}

const supportedLocales = [
  Locale('en', "US"), // English
  Locale('ur', "PK"), // URDU
  Locale('hi', "IN"), // HINDI
  Locale('ar', "SA"),
  Locale('id', "ID"), // ARABIC
  Locale('bn', "BD"), // BENGALI
  Locale('de', "DE"), // GERMAN
  Locale('zh', "CN"), // CHINESE
  Locale('it', "IT"), // Italian
  Locale('ja', "JP"), // Japanese
  Locale('ko', "KR"), // Korean
  Locale('fa', "IR"), // Persian
  Locale('pl', "PL"), // Polish
  Locale('pt', "PT"), // Portuguese in Portugal
  Locale('ru', "RU"), // Russian
  Locale('es', "ES"), // Spanish in Spain // Spanish in Latin America
  Locale('sv', "SE"), // Swedish
  Locale('ta', "IN"), // Tamil
  Locale('th', "TH"), // Thai
  Locale('tr', "TR"), // Turkish
  Locale('uk', "UA"), // Ukrainian
  Locale('vi', "VN"),
  Locale('fr', "FR"),
  Locale('nl', "NL"), // Vietnamese
];
Locale? localeResolutionCallback(deviceLocale, supportedLocale) {
  for (var local in supportedLocale) {
    if (local.languageCode == deviceLocale!.languageCode &&
        local.countryCode == deviceLocale.countryCode) {
      return deviceLocale;
    }
  }
  return supportedLocale.first;
}
