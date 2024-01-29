import 'package:flutter/material.dart';


class OnBoardingModel3 extends StatefulWidget {
  final String imageAssets;
  final String title;
  final String subtitle;
  final Widget? Button;
  const OnBoardingModel3(
      {super.key,
      required this.imageAssets,
      this.Button,
      required this.title,
      required this.subtitle});

  @override
  _OnBoardingModel3State createState() => _OnBoardingModel3State();
}

class _OnBoardingModel3State extends State<OnBoardingModel3> {
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
                widget.imageAssets,
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
