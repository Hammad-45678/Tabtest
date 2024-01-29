import 'package:flutter/material.dart';
import 'package:picstar/pages/onboarding_screens/comparison_screen.dart';

class OnBoardingModel extends StatefulWidget {
  final String image1;
  final String image2;
  final String title;
  final String subtitle;
  final Widget? Button;

  const OnBoardingModel({
    super.key,
    required this.image1,
    required this.title,
    required this.subtitle,
    this.Button,
    required this.image2,
  });

  @override
  State<OnBoardingModel> createState() => _OnBoardingModelState();
}

class _OnBoardingModelState extends State<OnBoardingModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 1.5,
                    child: comparisonAnimationOnboarding(
                      image1: AssetImage(widget.image1),
                      image2: AssetImage(widget.image2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: widget.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF8181FF),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
