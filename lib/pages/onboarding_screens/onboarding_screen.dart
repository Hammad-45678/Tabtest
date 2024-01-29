// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picstar/pages/onboarding_screens/language_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_screen_model.dart';
import 'onboarding_screen_model3.dart';
import 'onboarding_screen_model_2.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool islastPAge = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    PageController controller = PageController();
    int pageCount = 4;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        PageView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          children: const [
            OnBoardingModel(
              image1: 'assets/images/onboarding/image2.webp',
              image2: 'assets/images/onboarding/image1.webp',
              title: 'Achieving peak\nPerformance With\n',
              subtitle: 'Ai Enhancer.',
            ),
            OnBoardingModel(
              image1: 'assets/images/onboarding/BGRimage2.webp',
              image2: 'assets/images/onboarding/BGRimage1.webp',
              title: 'Perfect Your Visuals With \nAdvanced',
              subtitle: ' Background Removal.',
            ),
            OnBoardingModel2(
              imageAssets: [
                'assets/images/onboarding/OBRimage1.webp',
                'assets/images/onboarding/OBRimage2.webp',
              ],
              title: 'Effortless Image Object\nRemoval With ',
              subtitle: 'Ai Magic.',
            ),
            OnBoardingModel3(
              imageAssets: 'assets/images/object_replace.gif',
              title: 'Add Objects Effortlessly\nTo Images Using Perfect\n',
              subtitle: 'Prompt.',
            ),
          ],
          onPageChanged: (int page) {
            setState(() {
              islastPAge = page == pageCount - 1;
            });
          },
        ),
        Container(
          alignment: const Alignment(0, 0.80),
          child: SmoothPageIndicator(
            effect: const ExpandingDotsEffect(
                radius: 6, dotWidth: 15, dotHeight: 7, spacing: 2),
            controller: controller,
            count: pageCount,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('onboarding', 'done');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LanguageSelect()));
                  },
                  child: const Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // Check if there's a next page
                    if (controller.page! < pageCount - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                      );
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('onboarding', 'done');
                      // Navigate to the next screen or perform any other action
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LanguageSelect()),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/images/onboarding/forwordbotton.webp',
                    height: 40,
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
