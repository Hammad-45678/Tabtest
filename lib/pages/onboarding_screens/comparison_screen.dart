import 'package:flutter/material.dart';


class comparisonAnimationOnboarding extends StatefulWidget {
  final ImageProvider image1;
  final ImageProvider image2;
  const comparisonAnimationOnboarding(
      {super.key, required this.image1, required this.image2});
  @override
  _comparisonAnimationOnboardingState createState() =>
      _comparisonAnimationOnboardingState();
}

class _comparisonAnimationOnboardingState
    extends State<comparisonAnimationOnboarding>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.linear,
      ),
    ),
  );
  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.white, Colors.transparent],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstOut,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image(
                  image: widget.image1,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget? child) {
                    return ClipRect(
                      clipper: _ImageClipper(_animation.value),
                      child: Image(
                        image: widget.image2,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget? child) {
                  return Positioned(
                    top: constraints.maxHeight / 2 - 200,
                    left: constraints.maxWidth * _animation.value - 40,
                    child: const Center(
                      child: SizedBox(
                        width: 80,
                        height: 474,
                        child: Image(
                          image:
                              AssetImage('assets/icons/slider_vertical.webp'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageClipper extends CustomClipper<Rect> {
  final double clipFactor;
  _ImageClipper(this.clipFactor);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * clipFactor, size.height);
  }

  @override
  bool shouldReclip(_ImageClipper oldClipper) {
    return oldClipper.clipFactor != clipFactor;
  }
}
