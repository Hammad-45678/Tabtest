import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picstar/pages/home_screen/provider/shader_provider.dart';
import 'package:provider/provider.dart';

class ImageComparison extends StatefulWidget {
  final XFile image1;
  final String? image2;

  const ImageComparison(
      {super.key, required this.image1, required this.image2});

  @override
  _ImageComparisonState createState() => _ImageComparisonState();
}

class _ImageComparisonState extends State<ImageComparison> {
  double _sliderPosition = 0.1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderProvider>(builder: (context, shaderProvider, child) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate opacity values based on the slider position
          double beforeOpacity = _sliderPosition >= 0.7 ? 0.5 : 1.0;
          double afterOpacity = _sliderPosition <= 0.3 ? 0.5 : 1.0;
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error);
                      },
                      placeholder: (context, url) {
                        return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SpinKitSpinningLines(color: Color(0xFF8181FF)),
                            ]);
                      },
                      imageUrl: widget.image2!,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )),
              ),
              Positioned.fill(
                child: ClipRect(
                  clipper: _ImageClipper(_sliderPosition),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: FileImage(File(widget.image1.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: Opacity(
                  opacity: beforeOpacity,
                  child: Image.asset(
                    'assets/icons/after.webp',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                child: Opacity(
                  opacity: afterOpacity,
                  child: Image.asset(
                    'assets/icons/before.webp',
                    width: 55,
                    height: 50,
                  ),
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 2 - 150,
                left: constraints.maxWidth * _sliderPosition - 15,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    // Calculate the new slider position based on the drag gesture
                    setState(() {
                      _sliderPosition +=
                          details.primaryDelta! / constraints.maxWidth;
                      // Ensure the slider position stays within valid bounds
                      _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
                    });
                  },
                  child: const SizedBox(
                    width: 30,
                    height: 296,
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/icons/slider_vertical.webp'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class _ImageClipper extends CustomClipper<Rect> {
  final double clipFactor;

  _ImageClipper(this.clipFactor);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * clipFactor, size.height);
  }

  @override
  bool shouldReclip(_ImageClipper oldClipper) {
    return oldClipper.clipFactor != clipFactor;
  }
}
