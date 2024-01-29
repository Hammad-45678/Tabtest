import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:picstar/pages/object_remover_screen/widgets/magnifier/custom_magnifier.dart';
import 'package:picstar/pages/object_remover_screen/widgets/magnifier/magnifier_painter.dart';

class showmagnifier_widget extends StatelessWidget {
  const showmagnifier_widget({
    super.key,
    required this.dragGesturePosition,
  });

  final ui.Offset dragGesturePosition;

  @override
  Widget build(BuildContext context) {
    return CustomMagnifier(
      position: dragGesturePosition,
      visible: true,
      scale: 1.5,
      size: const Size(160, 160),
      child: const CustomPaint(
        painter: MagnifierPainter(color: Colors.black38),
      ),
    );
  }
}
