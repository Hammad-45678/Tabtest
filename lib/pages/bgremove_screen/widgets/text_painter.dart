import 'package:flutter/material.dart';

class CustomTextPainter {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;

  CustomTextPainter({
    required this.text,
    required this.textStyle,
    required this.textAlign,
  });

  void paint(Canvas canvas, Offset offset) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textOffset = offset;

    textPainter.paint(canvas, textOffset);
  }
}
