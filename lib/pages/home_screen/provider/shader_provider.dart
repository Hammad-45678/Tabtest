import 'package:flutter/material.dart';

class ShaderProvider with ChangeNotifier {
  late Shader _shader;

  ShaderProvider() {
    _shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.transparent, Colors.black],
      stops: [0.0, 0.3],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  }

  Shader get shader => _shader;
}
