import 'package:flutter/material.dart';
import 'package:picstar/pages/home_screen/provider/shader_provider.dart';

import 'package:provider/provider.dart';

class comparisonAnimation extends StatefulWidget {
  final ImageProvider image1;
  final ImageProvider image2;

  const comparisonAnimation(
      {super.key, required this.image1, required this.image2});

  @override
  _comparisonAnimationState createState() => _comparisonAnimationState();
}

class _comparisonAnimationState extends State<comparisonAnimation>
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
        curve: Curves.bounceIn,
      ),
      reverseCurve: const Interval(
        0.5,
        0.0,
        curve: Curves.easeIn,
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
    return Consumer<ShaderProvider>(builder: (context, shaderprovider, child) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ShaderMask(
            shaderCallback: (Rect bounds) => shaderprovider.shader,
            blendMode: BlendMode.dstIn,
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
                      top: constraints.maxHeight / 2 - 70,
                      left: constraints.maxWidth * _animation.value - 40,
                      child: const Center(
                        child: SizedBox(
                          width: 80,
                          height: 130,
                          child: Image(
                            image: AssetImage('assets/icons/slider.webp'),
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
    });
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
