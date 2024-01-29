import 'package:flutter/material.dart';
import 'package:picstar/pages/ai_generator_screen/show_enhanced.dart';
import 'package:picstar/pages/ai_generator_screen/text_to_image.dart';

import 'package:picstar/pages/ai_generator_screen/widgets/generating_artwork.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/inspirations.dart';
import 'package:picstar/pages/bgremove_screen/bg_remove.dart';

import 'package:picstar/pages/enhance_screen/components/advanced_settings.dart';
import 'package:picstar/pages/enhance_screen/pages/editphoto_screen.dart';

import 'package:picstar/pages/upload_photo_screen/uploadPhoto_screen.dart';

import 'package:picstar/pages/object_remover_screen/object_remover.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/ai_replace_screen/ai_replace.dart';
import '../../pages/home_screen/pages/home_page.dart';
import '../../pages/onboarding_screens/jump_in.dart';
import '../../pages/onboarding_screens/language_select.dart';
import '../../pages/paywall.dart';
import '../../revenue_cat/purchase_api.dart';

class RouteHelper {
  static const String initRoute = "/";
  static const String homepage = "/homepage";
  static const String enhanceImage = "/enhanceImage";
  static const String advancedSettings = "/advancedSettings";
  static const String editPhoto = "/editPhoto";
  static const String bgRemover = "/bgRemover";
  static const String aiGenerator = "/aiGenerator";
  static const String aiGeneratordialog = "/aiGeneratordialog";
  static const String text2ImageScreen2 = "/text2ImageScreen2";
  static const String objectRemove = "/objectRemove";
  static const String aiReplace = "/aiReplace";
  static const String inspirationsPage = "/inspirationsPage";
  static const String showEnhanced = "/showEnhanced";
  static const String onboarding = "/onboarding";
  static const String jumpIn = "/jumpIn";
  static const String languageSelect = "/languageSelect";
  static late BuildContext currentContext;
  String? onboardingValue;
  // static late BuildContext currentContext;
  Future<void> checkOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the 'onboarding' value from SharedPreferences
    onboardingValue = prefs.getString('onboarding') ?? '';
  }

  static Future<String?> getOnboardingValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('onboarding');
  }

  static Map<String, Widget Function(BuildContext)> routes(
      BuildContext context) {
    return {
      initRoute: (context) {
        currentContext = context;

        return FutureBuilder<String?>(
          future: getOnboardingValue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String? onboardingValue = snapshot.data;

              if (onboardingValue == 'done') {
                return home_page(); // or your home screen widget
              } else {
                return const SecondSplashScreen();
              }
            } else {
              // Show a loading indicator or another splash screen
              return const CircularProgressIndicator();
            }
          },
        );
      },
      enhanceImage: (context) {
        currentContext = context;
        return const UploadPhotoScreen();
      },
      advancedSettings: (context) {
        currentContext = context;
        return const AdvancedSettings();
      },
      editPhoto: (context) {
        currentContext = context;
        return EditPhoto();
      },
      bgRemover: (context) {
        currentContext = context;
        return const BgRemove();
      },
      aiGenerator: (context) {
        currentContext = context;
        return AiGenerator();
      },
      aiGeneratordialog: (context) {
        currentContext = context;
        return GeneratingArtwork(
          watchVideoCallback: () {},
          premiumCallback: () {},
        );
      },
      objectRemove: (context) {
        currentContext = context;
        return const ObjectRemover();
      },
      aiReplace: (context) {
        currentContext = context;
        return const AiReplace();
      },
      inspirationsPage: (context) {
        currentContext = context;
        return const InspirationsPage();
      },
      showEnhanced: (context) {
        currentContext = context;
        return const ShowEnhanced();
      },
      languageSelect: (context) {
        currentContext = context;
        return const LanguageSelect();
      }
    };
  }
}
