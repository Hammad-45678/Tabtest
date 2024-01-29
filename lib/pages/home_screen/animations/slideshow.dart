import 'dart:async';
import 'package:flutter/material.dart';
import 'package:picstar/pages/home_screen/pages/home_page.dart';
import 'package:picstar/pages/home_screen/provider/shader_provider.dart';

import 'package:provider/provider.dart';

class ImageSlideshow extends StatefulWidget {
  final List<String> imageAssets;
  final bool isUrdu;
  const ImageSlideshow(
      {super.key, required this.imageAssets, required this.isUrdu});

  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imageAssets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderProvider>(builder: (context, shaderprovider, child) {
      return ShaderMask(
        shaderCallback: (Rect bounds) => shaderprovider.shader,
        blendMode: BlendMode.dstIn,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: MediaQuery.of(context).size.shortestSide > 600
                  ? double.infinity
                  : 201,
              height: getContainerHeight(context),
              child: Image.asset(
                widget.imageAssets[_currentIndex],
                key: ValueKey<int>(_currentIndex),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    });
  }
}
