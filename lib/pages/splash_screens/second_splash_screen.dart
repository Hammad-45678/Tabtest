
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:picstar/pages/splash_screens/provider.dart';
import 'package:provider/provider.dart';

import '../onboarding_screens/onboarding_screen.dart';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SecondSplashScreen>
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
      body: Consumer<SplashScreenProvider>(
        builder: (context, splashProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
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
                    const SizedBox(height: 20),
                    const Text(
                      'Enhance your photo with AI Technology\nEasy, Fast and Reliable.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 180,
                          left: 20,
                          right: 20,
                        ),
                        child: InkWell(
                            onTap: () {
                              SecondSplashService splashScreen =
                                  SecondSplashService();
                              splashScreen.logIn(context);
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 45,
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment(-1.00, 0.00),
                                  end: Alignment(1, 0),
                                  colors: [
                                    Color(0xFF8181FF),
                                    Color(0xFFC74EC8)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: const Center(
                                  child: Text(
                                'Jump In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                  height: 0.05,
                                ),
                              )),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'By tapping',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Color(0xFF191C1A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '“continue”',
                            style: TextStyle(
                              color: Color(0xFF8181FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Color(0xFF191C1A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'you indicate that you have read\nour ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(
                              color: Color(0xFF8181FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SecondSplashService {
  void logIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }
}
