import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  void finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
