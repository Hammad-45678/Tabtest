import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageEditorPainterState extends ChangeNotifier {
  ui.Image? _image;
  List<Offset> _points = [];
  double _brushSize = 5.0;
  double _backgroundOpacity = 1.0;
  List<Offset> _apiPoints = [];

  ui.Image? get image => _image;
  List<Offset> get points => _points;
  double get brushSize => _brushSize;
  double get backgroundOpacity => _backgroundOpacity;
  List<Offset> get apiPoints => _apiPoints;

  void setImage(ui.Image? newImage) {
    _image = newImage;
    notifyListeners();
  }

  void setPoints(List<Offset> newPoints) {
    _points = newPoints;
    notifyListeners();
  }

  void setBrushSize(double newSize) {
    _brushSize = newSize;
    notifyListeners();
  }

  void setBackgroundOpacity(double newOpacity) {
    _backgroundOpacity = newOpacity;
    notifyListeners();
  }

  void setApiPoints(List<Offset> newApiPoints) {
    _apiPoints = newApiPoints;
    notifyListeners();
  }
}
