import 'package:flutter/material.dart';
import 'package:picstar/pages/home_screen/provider/shader_provider.dart';

import 'package:provider/provider.dart';

class bgremove_animation extends StatefulWidget {
  final ImageProvider image1;
  final ImageProvider image2;

  const bgremove_animation(
      {super.key, required this.image1, required this.image2});

  @override
  _bgremove_animationState createState() => _bgremove_animationState();
}

class _bgremove_animationState extends State<bgremove_animation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation =
      Tween<double>(begin: 1, end: 0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.easeInOutExpo,
      ),
      reverseCurve: const Interval(
        0.5,
        0.0,
        curve: Curves.easeInOutExpo,
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
          return Stack(
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
                          image: AssetImage('assets/images/slider2.webp'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
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
