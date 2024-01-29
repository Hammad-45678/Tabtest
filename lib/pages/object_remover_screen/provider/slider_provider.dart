import 'package:flutter/material.dart';

class SliderProvider extends ChangeNotifier {
  double _value = 20.0;
  bool _isBrushEnabled = false;
  double get value => _value;
  bool get isBrushEnabled => _isBrushEnabled;
  void updateValue(double newValue) {
    _value = newValue;
    notifyListeners();
  }

  void toggleSlider() {
    _isBrushEnabled = !_isBrushEnabled;
    notifyListeners();
  }
}
