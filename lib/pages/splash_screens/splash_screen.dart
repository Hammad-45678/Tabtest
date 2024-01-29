import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:picstar/pages/splash_screens/provider.dart';
import 'package:picstar/pages/splash_screens/second_splash_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4, milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });

    // Start the animation
    controller.repeat(reverse: false);

    // Call your SplashService login method here if needed
    SplashService splashScreen = SplashService();
    splashScreen.logIn(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The rest of your build method remains unchanged
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Consumer<SplashScreenProvider>(
          builder: (context, splashProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: controller, // Use the controller directly here
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/applogo.webp',
                      height: 156,
                    ),
                  ),
                ),
                SizedBox(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Picstar',
                        textStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10.44,
                        ),
                        colors: [
                          const Color(0xFF8181FF),
                          Colors.pink,
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 85, left: 20, right: 20),
                  child: LinearProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SplashService {
  void logIn(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      // Finish loading and navigate to the next screen
      Provider.of<SplashScreenProvider>(context, listen: false).finishLoading();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondSplashScreen()),
      );
    });
  }
}
