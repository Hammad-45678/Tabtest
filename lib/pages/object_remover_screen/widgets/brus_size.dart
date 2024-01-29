import 'package:flutter/material.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';

import 'package:provider/provider.dart';

class showbrushSize_widget extends StatelessWidget {
  const showbrushSize_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Consumer<ImagePickerProvider>(
          builder: (context, imageeditorprovider, child) {
        return Center(
          child: Container(
            width: imageeditorprovider.brushSize * 1,
            height: imageeditorprovider.brushSize * 1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0),
            ),
          ),
        );
      }),
    );
  }
}
