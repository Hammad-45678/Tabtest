import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const PaintingDemo());
}

class PaintingDemo extends StatelessWidget {
  const PaintingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ImagePainterProvider(),
        child: const ImagePaintScreen(),
      ),
    );
  }
}

class ImagePainterProvider with ChangeNotifier {
  ui.Image? _image;
  ui.Image? get image => _image;
  Size? _imageSize;
  Size? get imageSize => _imageSize;
  double _brushSize = 40.0; // Default brush size
  double get brushSize => _brushSize;
  List<Offset> points = [];
  bool shouldRedraw = false;
  void setBrushSize(double newSize) {
    _brushSize = newSize;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final data = await pickedFile.readAsBytes();
      final img = await decodeImageFromList(data);
      _image = img;
      _imageSize = Size(img.width.toDouble(), img.height.toDouble());
      notifyListeners();
    }
  }

  void addPoint(Offset point) {
    points = List.from(points)..add(point);
    shouldRedraw = true;
    notifyListeners();
  }

  void clearPoints() {
    points = [];
    shouldRedraw = true;
    notifyListeners();
  }
}

class ImagePaintScreen extends StatelessWidget {
  const ImagePaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw on Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {
              Provider.of<ImagePainterProvider>(context, listen: false)
                  .pickImage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Provider.of<ImagePainterProvider>(context, listen: false)
                  .clearPoints();
            },
          ),
          Slider(
            value: Provider.of<ImagePainterProvider>(context, listen: false)
                .brushSize,
            min: 1.0,
            max: 100.0,
            divisions: 99,
            label: 'Brush Size',
            onChanged: (value) {
              Provider.of<ImagePainterProvider>(context, listen: false)
                  .setBrushSize(value);
            },
          ),
        ],
      ),
      body: Consumer<ImagePainterProvider>(
        builder: (context, imagePainterProvider, child) {
          if (imagePainterProvider.image == null) {
            return const Center(child: Text('Select an image to start drawing.'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ClipRect(
              child: Container(
                height: MediaQuery.sizeOf(context).height / 2,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: CustomPaint(
                  painter: ImagePainter(
                      imagePainterProvider.image,
                      imagePainterProvider.points,
                      imagePainterProvider.brushSize),
                  size: imagePainterProvider.imageSize!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image? image;
  final List<Offset> points;
  final double brushSize;
  ImagePainter(this.image, this.points, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.width, size.height),
          image: image!,
          fit: BoxFit.fill);
    }

    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 40
      ..blendMode = BlendMode.color;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
