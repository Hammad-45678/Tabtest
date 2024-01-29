import 'package:flutter/material.dart';

class TextControllerProvider extends ChangeNotifier {
  late TextEditingController textController;

  TextControllerProvider() {
    textController = TextEditingController();
  }

  void setText(String text) {
    textController.text = text;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
