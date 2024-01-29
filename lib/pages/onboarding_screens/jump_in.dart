import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../splash_screens/provider.dart';
import 'onboarding_screen.dart';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SecondSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AnimationController controller2;
  late bool isLogoAnimationCompleted = false;
  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        setState(() {});
      });
    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {});
      });
    controller2.repeat(reverse: true);
    // Start the animation
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isLogoAnimationCompleted = true;
        });
      }
    });
    // Call your SplashService login method here if needed
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
                      opacity: controller,
                      child: ScaleTransition(
                        scale: CurvedAnimation(
                            parent: controller, curve: Curves.elasticOut),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/images/picstarlogo.webp',
                            height: 156,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250.0,
                      height: 50,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                        child: Center(
                          child: isLogoAnimationCompleted
                              ? AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'Picstar',
                                      textStyle: const TextStyle(
                                        color: Color(0xFF8181FF),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                        letterSpacing: 10.44,
                                      ),
                                      speed: const Duration(milliseconds: 100),
                                    ),
                                  ],
                                  totalRepeatCount: 1,
                                )
                              : Container(
                                  height: 50,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLogoAnimationCompleted
                        ? FadeTransition(
                            opacity: controller,
                            child: const Text(
                              'Enhance your photo with AI Technology\nEasy, Fast and Reliable.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : Container(
                            height: 50,
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
                            child: isLogoAnimationCompleted
                                ? ScaleTransition(
                                    scale: Tween<double>(begin: 1, end: 1.1)
                                        .animate(controller2),
                                    child: Container(
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
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'Jump In',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                    ),
                                  )
                                : Container(
                                    height: 45,
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
