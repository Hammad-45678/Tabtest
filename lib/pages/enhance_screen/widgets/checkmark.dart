import 'package:flutter/material.dart';

class AnimatedCheckIcon extends StatelessWidget {
  final AnimationController animationController;
  final double size;
  final Color color;

  const AnimatedCheckIcon({super.key, 
    required this.animationController,
    this.size = 24.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: animationController.value,
          child: Icon(
            Icons.check,
            size: size,
            color: color,
          ),
        );
      },
    );
  }
}
