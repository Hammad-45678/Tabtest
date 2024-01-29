import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:picstar/translation_manager/translations.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale =
      Hive.box("myBox").get("languageCode") ?? const Locale("en", "US");
  Locale get locale => _locale;
  void setLocale(Languages languages) async {
    switch (languages.languageCode) {
      case "en":
        _locale = Locale(languages.languageCode, "US");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ur":
        _locale = Locale(languages.languageCode, "PK");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "hi":
        _locale = Locale(languages.languageCode, "IN");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ar":
        _locale = Locale(languages.languageCode, "SA");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "id":
        _locale = Locale(languages.languageCode, "ID");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "bn":
        _locale = Locale(languages.languageCode, "BD");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "zh":
        _locale = Locale(languages.languageCode, "CN");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "fr":
        _locale = Locale(languages.languageCode, "FR");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;

      case "es":
        _locale = Locale(languages.languageCode, "ES");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "de":
        _locale = Locale(languages.languageCode, "DE");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "nl":
        _locale = Locale(languages.languageCode, "NL");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "it":
        _locale = Locale(languages.languageCode, "IT");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ja":
        _locale = Locale(languages.languageCode, "JP");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ko":
        _locale = Locale(languages.languageCode, "KR");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "fa":
        _locale = Locale(languages.languageCode, "IR");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "pl":
        _locale = Locale(languages.languageCode, "PL");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "pt":
        _locale = Locale(languages.languageCode, "PT");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ru":
        _locale = Locale(languages.languageCode, "RU");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;

      case "sv":
        _locale = Locale(languages.languageCode, "SE");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "ta":
        _locale = Locale(languages.languageCode, "IN");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "th":
        _locale = Locale(languages.languageCode, "TH");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "tr":
        _locale = Locale(languages.languageCode, "TR");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "uk":
        _locale = Locale(languages.languageCode, "UA");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
      case "vi":
        _locale = Locale(languages.languageCode, "VN");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;

      default:
        _locale = const Locale("en", "US");
        Hive.box("myBox").put("languageCode", _locale);
        notifyListeners();
        break;
    }
  }

  checkIsArOrUr() {
    if (_locale.languageCode == "ur" ||
        _locale.languageCode == 'ar' ||
        _locale.languageCode == 'fa') {
      return true;
    } else {
      return false;
    }
  }
}
