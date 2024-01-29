import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';

class textAnimation extends StatefulWidget {
  const textAnimation({Key? key}) : super(key: key);

  @override
  _textAnimationState createState() => _textAnimationState();
}

class _textAnimationState extends State<textAnimation> {
  int _currentTextIndex = 0;

  final List<String> _textKeys = [
    'capture_miniature_wonders_in_daily_life',
    'city_street_at_dusk_with_people_and_vehicles_under_neon_lights',
    'an_image_that_blurs_the_line_between_dream_and_reality',
    // Add more keys for other texts
  ];
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex =
              (_currentTextIndex + 1) % _textKeys.length; // Loop through texts
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 20 : 12;
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: 1.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 10, right: 10),
        child: Text(
          localeText(
            context,
            _textKeys[_currentTextIndex],
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
    );
  }
}
