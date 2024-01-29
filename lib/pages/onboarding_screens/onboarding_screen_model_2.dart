import 'dart:async';
import 'package:flutter/material.dart';


class OnBoardingModel2 extends StatefulWidget {
  final List<String> imageAssets;

  final String title;
  final String subtitle;
  final Widget? Button;
  const OnBoardingModel2(
      {super.key,
      required this.imageAssets,
      required this.title,
      required this.subtitle,
      this.Button});

  @override
  _OnBoardingModel2State createState() => _OnBoardingModel2State();
}

class _OnBoardingModel2State extends State<OnBoardingModel2> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imageAssets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Colors.transparent],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Use your desired transition, for example, FadeTransition
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.asset(
                widget.imageAssets[_currentIndex],
                key: ValueKey<int>(_currentIndex),
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height / 1.5,
              ),
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
        ]),
      ]),
    );
  }
}
