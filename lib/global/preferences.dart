// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences prefs;

  static void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static const String ASK_AGAIN = "askAgain";
  static const String IMAGE_TYPE = "imageType";
  static const String APP_THEME = "appTheme";
  static const String INSPIRATION_DATA = "inspirationData";
  static const String LANGUAGE_LOCALE = "languageLocale";
  static const String USER_PRO_ID = "userProId";
  static const String PRO_FEATURE = "proFeature";

  static const String THEME_DEFAULT = "System Default";
  static const String THEME_LIGHT = "Light";
  static const String THEME_DARK = "Dark";

  static const String IMAGE_JPG = "jpeg";
  static const String IMAGE_PNG = "png";
  static const String IMAGE_WEBP = "webp";

  static String get imageType => prefs.getString(IMAGE_TYPE) ?? IMAGE_JPG;

  static set imageType(String value) => prefs.setString(IMAGE_TYPE, value);

  static String get appTheme => prefs.getString(APP_THEME) ?? THEME_DEFAULT;

  static set appTheme(String value) => prefs.setString(APP_THEME, value);

  static bool get askAgain => prefs.getBool(ASK_AGAIN) ?? false;

  static set askAgain(bool value) => prefs.setBool(ASK_AGAIN, value);

  static String get inspirationData => prefs.getString(INSPIRATION_DATA) ?? "";

  static set inspirationData(String value) =>
      prefs.setString(INSPIRATION_DATA, value);

  static String get languageLocale => prefs.getString(LANGUAGE_LOCALE) ?? "";

  static set languageLocale(String value) =>
      prefs.setString(LANGUAGE_LOCALE, value);

  static bool get proFeature => prefs.getBool(PRO_FEATURE) ?? false;

  static set proFeature(value) => prefs.setBool(PRO_FEATURE, value);

  static String? getUserProId() => prefs.getString(USER_PRO_ID);

  static set userProId(String value) => prefs.setString(USER_PRO_ID, value);
}
