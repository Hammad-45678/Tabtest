import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';

import 'package:picstar/pages/home_screen/provider/shader_provider.dart';
import 'package:picstar/pages/object_remover_screen/provider/slider_provider.dart';
import 'package:picstar/pages/splash_screens/provider.dart';

import 'package:picstar/shared/routes/routes.dart';
import 'package:picstar/translation_manager/localization_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/global.dart';
import 'global/preferences.dart';
import 'global/widgets/ad_manager.dart';
import 'pages/ai_generator_screen/provider/textEditingprovider.dart';

import 'pages/enhance_screen/provider/dynamic_loadingProvider.dart';
import 'revenue_cat/purchase_api.dart';
import 'translation_manager/language_constants.dart';
import 'translation_manager/localization_demo.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

List<String> testDeviceIds = ['9FC54492AC8DB62'];
void main() async {
  await Global.init();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MobileAds.instance.initialize();
  // await RevenueCat.configStore();
  Preferences.initPrefs();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ShaderProvider>(create: (_) => ShaderProvider()),
      ChangeNotifierProvider<ImagePickerProvider>(
          create: (_) => ImagePickerProvider()),
      ChangeNotifierProvider<SliderProvider>(create: (_) => SliderProvider()),
      ChangeNotifierProvider<TextControllerProvider>(
          create: (_) => TextControllerProvider()),
      ChangeNotifierProvider<SplashScreenProvider>(
          create: (_) => SplashScreenProvider()),
      ChangeNotifierProvider<LocalizationProvider>(
          create: (_) => LocalizationProvider()),
      ChangeNotifierProvider<LoadingTextData>(create: (_) => LoadingTextData()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Consumer<LocalizationProvider>(builder: (context, value, child) {
      return MaterialApp(
        locale: value.locale,
        localizationsDelegates: [
          LocalizationDemo.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        localeResolutionCallback: localeResolutionCallback,
        theme: ThemeData(
          fontFamily: GoogleFonts.urbanist().fontFamily,
          // Add other theme configurations here
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: RouteHelper.initRoute,
        routes: RouteHelper.routes(context),
      );
    });
  }
}
