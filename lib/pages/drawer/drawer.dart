import 'package:flutter/material.dart';
import 'package:picstar/pages/drawer/image_setting.dart';
import 'package:picstar/pages/drawer/language_bottom_sheet.dart';
import 'package:picstar/pages/drawer/theme_screen.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../global/widgets/custom_app_bar_wdiget.dart';
import '../../translation_manager/localization_provider.dart';
import 'General_setting_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for the drawer width

    return Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          height: 50,
          firstleadingImage: Image.asset(
            'assets/icons/btn_back.webp',
            width: 24,
            height: 24,
          ),
          secondleadingImage: Image.asset(
            'assets/icons/frwrd-btn.webp',
            width: 24,
            height: 24,
          ),
          title: Consumer<LocalizationProvider>(builder: (BuildContext context,
              LocalizationProvider value, Widget? child) {
            return Text(
                localeText(
                  context,
                  'settings',
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: value.checkIsArOrUr() ? 14 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: value.checkIsArOrUr() ? 0 : 3.60,
                ));
          }),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset('assets/images/card.webp'),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 36,
                    child: SizedBox(
                        height: 50,
                        width: 100,
                        child: Image.asset('assets/images/button.webp')))
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeText(
                          context,
                          'general',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.80,
                        ),
                      ),
                      GeneralSettingContainer(
                          leadingicon: 'assets/images/languageicon.webp',
                          text: localeText(context, 'language'),
                          trailingicon: Icons.arrow_forward_ios,
                          onpressed: () {
                            _showLanguageBottomSheet(context);
                          }),
                      GeneralSettingContainer(
                        leadingicon: 'assets/images/imagesettingicon.webp',
                        text: localeText(context, 'image_settings'),
                        trailingicon: Icons.arrow_forward_ios,
                        onpressed: () {
                          _imageSettingBottomSheet(context);
                        },
                      ),
                      GeneralSettingContainer(
                        leadingicon: 'assets/images/theme 1.webp',
                        text: localeText(context, 'app_theme'),
                        trailingicon: Icons.arrow_forward_ios,
                        onpressed: () {
                          _themeSettingBottomSheet(context);
                        },
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'others',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.80,
                              ),
                            ),
                            GeneralSettingContainer(
                              leadingicon: 'assets/images/shareicon.webp',
                              text: localeText(context, 'share_app'),
                              onpressed: () {
                                Share.share('com.example.picstaololr');
                              },
                            ),
                            GeneralSettingContainer(
                              onpressed: () {},
                              leadingicon: 'assets/images/rateicon.webp',
                              text: localeText(context, 'rate_us'),
                            ),
                            GeneralSettingContainer(
                              onpressed: () {},
                              leadingicon: 'assets/images/feedbackicon.webp',
                              text: localeText(context, 'feedback'),
                            ),
                            GeneralSettingContainer(
                              onpressed: () {},
                              leadingicon: 'assets/images/privacyicon.webp',
                              text: localeText(context, 'privacy_policy'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}

void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return const LanguageBottomSheet();
    },
  );
}

//////////// Bottom sheet for images setting /////////////////////////

void _imageSettingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF222222),
    context: context,
    builder: (BuildContext context) {
      return const RadioSelectionBottomSheet();
    },
  );
}

///// App Theme Bottom Sheet/////////////////////////

void _themeSettingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF222222),
    context: context,
    builder: (BuildContext context) {
      return const ThemeBottomSheet();
    },
  );
}

/////////////////   Share App Bottom sheet

