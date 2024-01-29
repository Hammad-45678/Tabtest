import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Videos extends StatelessWidget {
  const Videos({super.key});
  static const id = "Videos";
  @override
  Widget build(BuildContext context) {
    return const MyCanvas();
  }
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({super.key});

  @override
  _MyCanvasState createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  List<PointOrMarker> points = [];
  Color currentColor = Colors.white;
  double strokeWidth = 15.0;
  bool isErasing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isErasing.toString(),
          style: const TextStyle(color: Colors.amber),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localPosition =
                renderBox.globalToLocal(details.localPosition);

            // Handle erasing logic
            if (isErasing) {
              replacePointsInRadius(localPosition, 40.0);
            } else {
              points.add(PointOrMarker(localPosition));
            }
          });
        },
        onPanEnd: (details) {
          setState(() {
            // Handle adding a marker for the end of a stroke based on erasing state
            if (!isErasing) {
              points.add(PointOrMarker(null));
            }
          });
        },
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://cognise.art/media/txt2img/063bea39-312f-4539-9df7-c4504adf5b99.png",
              height: MediaQuery.sizeOf(context).height,
              fit: BoxFit.cover,
            ),
            CustomPaint(
              painter: MyPainter(points, currentColor, strokeWidth, isErasing),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isErasing = !isErasing;
          });
        },
        child: Icon(isErasing ? Icons.edit : Icons.brush),
      ),
    );
  }

  void replacePointsInRadius(Offset point, double radius) {
    for (int i = 0; i < points.length; i++) {
      if (points[i].isPoint && (points[i].point! - point).distance <= radius) {
        points[i] = PointOrMarker(null);
      }
    }
  }

  // Remove points within a certain radius from the specified point
  void removePointsInRadius(Offset point, double radius) {
    points.removeWhere((pointOrMarker) =>
        pointOrMarker.isPoint &&
        pointOrMarker.point != null &&
        (pointOrMarker.point! - point).distance <= radius);
  }
}

class PointOrMarker {
  final Offset? point; // Offset representing a point, or null as a marker
  PointOrMarker(this.point);

  bool get isPoint => point != null;
}

class MyPainter extends CustomPainter {
  final List<PointOrMarker> points;
  final Color color;
  final double strokeWidth;
  final bool isErasing;

  MyPainter(this.points, this.color, this.strokeWidth, this.isErasing);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isPoint && points[i + 1].isPoint) {
        // if (isErasing) {
        //   paint.blendMode = BlendMode.clear;
        // } else {

        // }
        paint.blendMode = BlendMode.srcOver;
        canvas.drawLine(points[i].point!, points[i + 1].point!, paint);
      } else if (points[i].isPoint && !points[i + 1].isPoint) {
        canvas.drawPoints(PointMode.points, [points[i].point!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
