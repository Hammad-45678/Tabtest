import 'package:flutter/material.dart';

class LoadingTextData with ChangeNotifier {
  String _loadingText = "Loading...";
  String _generatingText = "Initializing...";
  String _resultText = "Result";

  String get loadingText => _loadingText;
  String get generatingText => _generatingText;
  String get resultText => _resultText;

  void setLoadingText(String newText) {
    _loadingText = newText;
    notifyListeners();
  }

  void setGeneratingText(String newText) {
    _generatingText = newText;
    notifyListeners();
  }

  void setResultText(String newText) {
    _resultText = newText;
    notifyListeners();
  }
}
