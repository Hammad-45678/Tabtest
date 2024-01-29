import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';

class ImageEditorPainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> points;
  final List<Offset> apiPoints;
  final double brushSize;
  final double backgroundOpacity;

  ImageEditorPainter(
    this.image,
    this.points,
    this.brushSize,
    this.backgroundOpacity,
    this.apiPoints,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the original image
    canvas.drawImage(image, Offset.zero, Paint());
    // Draw the background rectangle with the specified opacity after drawing the red lines
    Paint backgroundPaint = Paint()..color = Colors.black.withOpacity(0);
    Color darkRedColor = const ui.Color.fromARGB(
        255, 162, 53, 53); // Draw the red lines with partial transparency
    Paint redPaint = Paint()
      ..color = darkRedColor // Adjust the opacity as needed
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize
      ..blendMode = BlendMode.darken;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != const Offset(-1, -1) &&
          points[i + 1] != const Offset(-1, -1)) {
        canvas.drawLine(points[i], points[i + 1], redPaint);
      }
    }
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
