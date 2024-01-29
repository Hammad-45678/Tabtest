import 'package:flutter/material.dart';

class ShaderProvider2 with ChangeNotifier {
  late Shader _shader;
  ShaderProvider2() {
    _shader = LinearGradient(
      begin: const Alignment(0.00, -1.00), // Start from the bottom
      end: const Alignment(0, 1), // End at the top
      colors: [
        Colors.white,
        Colors.white.withOpacity(0)
      ], // Black to white gradient
      stops: const [0.1, 0.9],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 10.0));
  }
  Shader get shader => _shader;
}
