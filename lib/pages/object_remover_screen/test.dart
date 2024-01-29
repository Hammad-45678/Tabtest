import 'dart:typed_data';
import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  final Uint8List editedImageBytes;

  const NextScreen({super.key, required this.editedImageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edited Image'),
      ),
      body: Center(
        child: Image.memory(editedImageBytes),
      ),
    );
  }
}
