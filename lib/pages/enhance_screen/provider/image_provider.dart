import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class ImagePickerProvider extends ChangeNotifier {
  XFile? _image;
  String _enhancedImageURL = '';
  final bool _isProcessing = false;
  Uint8List? _bgRemovedImage;
  XFile? get image => _image;
  String get enhancedImageURL => _enhancedImageURL;
  bool get isProcessing => _isProcessing;
  Uint8List? get bgRemovedImage => _bgRemovedImage;
  // Use a method to update _enhancedImageURL
  double _samplingStepsSlider = 20;

  double get samplingStepsSlider => _samplingStepsSlider;
  void updateSamplingSliderValue(double value) {
    _samplingStepsSlider = value;
    notifyListeners();
  }

  Future<bool> getImageFromGallery() async {
    final imagePicker = ImagePicker();

    try {
      final pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery, requestFullMetadata: true);

      if (pickedFile != null) {
        // Check the image format here (for example, allow JPEG and PNG):

        XFile? imageToUse;

        // Check if the platform is Android
        if (Platform.isAndroid) {
          // If Android, compress the image
          imageToUse = await compressAndGetFile(pickedFile.path);
        } else {
          // If not Android, use the original image
          imageToUse = pickedFile;
        }

        if (imageToUse != null) {
          _image = imageToUse;
          _enhancedImageURL = '';
          notifyListeners();
          return true;
        }
      } else {
        print('No image selected.');
      }
    } on PlatformException catch (e) {
      print('Error picking image from gallery: ${e.message}');
    }
    return false;
  }

  Future<XFile?> compressAndGetFile(String imagePath) async {
    Uint8List? result = await FlutterImageCompress.compressWithFile(
      imagePath,
      quality: 85,
    );

    // Create a new XFile with the compressed image bytes
    XFile? compressedImage = await saveImage(result!);

    return compressedImage;
  }

  Future<XFile?> saveImage(List<int> imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile =
        File('$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await tempFile.writeAsBytes(imageBytes);

    return XFile(tempFile.path);
  }

  Future<ui.Image?> getImageFromGallery2() async {
    _points.clear();
    _apiPoints.clear();

    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();

      // Resize the image to 400x400
      // final ByteData data =
      //     ByteData.sublistView(Uint8List.fromList(imageBytes));
      // final ui.Codec codec =
      //     await ui.instantiateImageCodec(Uint8List.view(data.buffer));
      // final ui.FrameInfo frameInfo = await codec.getNextFrame();

      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 800, // Set your desired minimum height
        minWidth: 800, // Set your desired minimum width
      );

      // Resize the compressed image to 400x400
      final ByteData data =
          ByteData.sublistView(Uint8List.fromList(compressedBytes));
      final ui.Codec codec =
          await ui.instantiateImageCodec(Uint8List.view(data.buffer));
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      originalImage = frameInfo.image;
      return originalImage;
    }
    // if (pickedFile != null) {
    //   clearImage();
    //   _image = pickedFile;
    //   _enhancedImageURL = '';
    //   notifyListeners();
    //   return true;
    // } return null;
    return null;
  }

  void clearImage() {
    _image = null;
  }

  // New method to set the processed image
  void setBgRemovedImage(String processedImage) {
    _bgRemovedImage = bgRemovedImage;
    notifyListeners();
  }

  // Add a new method to clear processed image
  void clearbgRemovedImage() {
    _bgRemovedImage = null;
    notifyListeners();
  }

  void setImage(XFile image) {
    _image = image;
    _enhancedImageURL = '';
    notifyListeners();
  }

  Future<bool> getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Rotate the image to correct orientation
      final rotatedFile =
          await FlutterExifRotation.rotateImage(path: pickedFile.path);

      _image = XFile(rotatedFile.path);
      _enhancedImageURL = '';
      notifyListeners();
      return true;
    }
    return false;
  }

  void setImagePath(String path) {
    _image = XFile(path);
    _enhancedImageURL = '';
    notifyListeners();
  }

  List<Offset> _points = [];
  final List<Offset> _points2 = [];
  final List<Offset> _erasePoints = [];
  List<Offset> _apiPoints = [];
  final List<Offset> _apiPoints2 = [];
  double _brushSize = 50.0;
  double _brushSizeerase = 50.0;
  List<Offset> get points => _points;
  List<Offset> get points2 => _points2;
  List<Offset> get apiPoints => _apiPoints;
  List<Offset> get apiPoints2 => _apiPoints2;
  List<Offset> get erasePoints => _erasePoints;

  double get brushSize => _brushSize;
  double get brushSizeerase => _brushSizeerase;
  Uint8List? _apiResponseImageBytes;
  ui.Image? _originalImage;

  String _promptText = "";
  final TextEditingController _promptController = TextEditingController();

  String get promptText => _promptText;
  TextEditingController get promptController => _promptController;

  final TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;

  bool _isSliderChanging = false;
  bool get isSliderChanging => _isSliderChanging;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingAiImage = false;
  bool get isLoadingAiImage => _isLoadingAiImage;
  bool _isTouching = false;
  bool get isTouching => _isTouching;

  double _backgroundOpacity = 0.5;
  double get backgroundOpacity => _backgroundOpacity;

  Uint8List? get apiResponseImageBytes => _apiResponseImageBytes;
  ui.Image? get originalImage => _originalImage;

  double _zoom = 1.0;
  Offset _offset = Offset.zero;

  double get zoom => _zoom;
  Offset get offset => _offset;

  Offset _dragGesturePosition = Offset.zero;
  Offset get dragGesturePosition => _dragGesturePosition;

  List<List<Offset>> undoStack = [];
  List<List<Offset>> redoStack = [];

  void updateZoom(double scale) {
    _zoom = scale;
    notifyListeners();
  }

  void updateOffset(Offset offset) {
    _offset = offset;
    notifyListeners();
  }

// Future<void> loadImage() async {
//     _points.clear();
//     _apiPoints.clear();
//     // Put your logic for loading the image here
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final imageBytes = await pickedFile.readAsBytes();

//       // Resize the image to 400x400
//       // final ByteData data =
//       //     ByteData.sublistView(Uint8List.fromList(imageBytes));
//       // final ui.Codec codec =
//       //     await ui.instantiateImageCodec(Uint8List.view(data.buffer));
//       // final ui.FrameInfo frameInfo = await codec.getNextFrame();

//       final compressedBytes = await FlutterImageCompress.compressWithList(
//         imageBytes,
//         minHeight: 800, // Set your desired minimum height
//         minWidth: 800, // Set your desired minimum width
//       );

//       // Resize the compressed image to 400x400
//       final ByteData data =
//           ByteData.sublistView(Uint8List.fromList(compressedBytes));
//       final ui.Codec codec =
//           await ui.instantiateImageCodec(Uint8List.view(data.buffer));
//       final ui.FrameInfo frameInfo = await codec.getNextFrame();

//       originalImage = frameInfo.image;
//     }
//   }
  Future<void> loadImage() async {
    _points.clear();
    _apiPoints.clear();
    // Put your logic for loading the image here
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();

      Uint8List processedBytes;

      // Check if the platform is Android
      if (Platform.isAndroid) {
        // Perform compression on Android
        processedBytes = await FlutterImageCompress.compressWithList(
          imageBytes,
          minHeight: 800, // Set your desired minimum height
          minWidth: 800, // Set your desired minimum width
        );
      } else {
        // Do not compress for iOS
        processedBytes = imageBytes;
      }

      // Resize the processed image (compressed for Android, original for iOS) to 400x400
      final ByteData data =
          ByteData.sublistView(Uint8List.fromList(processedBytes));
      final ui.Codec codec =
          await ui.instantiateImageCodec(Uint8List.view(data.buffer));
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      originalImage = frameInfo.image;
    }
  }

  Future<void> loadImagefromcamera() async {
    _points.clear();
    _apiPoints.clear();
    // Put your logic for loading the image here
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();

      // Resize the image to 400x400
      // final ByteData data =
      //     ByteData.sublistView(Uint8List.fromList(imageBytes));
      // final ui.Codec codec =
      //     await ui.instantiateImageCodec(Uint8List.view(data.buffer));
      // final ui.FrameInfo frameInfo = await codec.getNextFrame();

      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 800, // Set your desired minimum height
        minWidth: 800, // Set your desired minimum width
      );

      // Resize the compressed image to 400x400
      final ByteData data =
          ByteData.sublistView(Uint8List.fromList(compressedBytes));
      final ui.Codec codec =
          await ui.instantiateImageCodec(Uint8List.view(data.buffer));
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      originalImage = frameInfo.image;
    }
  }

  set originalImage(ui.Image? image) {
    _originalImage = image;
    notifyListeners();
  }

  void addPointWithBrushSize(Offset point) {
    _points.add(point);
    _apiPoints.add(point);
    _brushSize = brushSize;
    _erasePoints.add(point);
    // Clear the redo history when a new point is added
    // Update the brush size
    notifyListeners();
  }

  void addPointWithErase(Offset point) {
    _points2.add(point);
    _apiPoints2.add(point);
    _brushSizeerase = brushSize;

    // Clear the redo history when a new point is added
    // Update the brush size
    notifyListeners();
  }

  void addPoint2(
    Offset point,
  ) {
    _points2.add(point);
    _apiPoints2.add(point);

    notifyListeners();
  }

  void addPoint(
    Offset point,
  ) {
    _points.add(point);
    _apiPoints.add(point);
    _erasePoints.add(point);
    notifyListeners();
  }

  void resetPoints() {
    _points = [];
    _apiPoints = [];
    notifyListeners();
  }

  void clearPoints() {
    _points.clear();
    _apiPoints.clear();
    notifyListeners();
  }

  void updateBrushSize(double size) {
    _brushSize = size;
    notifyListeners();
  }

  void setApiResponseImageBytes(Uint8List bytes) {
    _apiResponseImageBytes = bytes;
    notifyListeners();
  }

  void setOriginalImage(ui.Image? image) {
    _originalImage = image;
    notifyListeners();
  }

  void setSliderChanging(bool value) {
    _isSliderChanging = value;
    notifyListeners();
  }

  void setLoadingAnimation(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoadingAnimationForAIImage(bool value) {
    _isLoadingAiImage = value;
    notifyListeners();
  }

  void setIsTouching(bool value) {
    _isTouching = value;
    notifyListeners();
  }

  void setBackgroundOpacity(double value) {
    _backgroundOpacity = value;
    notifyListeners();
  }

  void setPromptText(String text) {
    _promptText = text;
    notifyListeners();
  }

  void disposeControllers() {
    _promptController.dispose();
  }

  void clearTextField() {
    _promptController.clear();
  }

  void updateDragGesturePosition(Offset position) {
    _dragGesturePosition = position;
    notifyListeners();
  }

  // Method to finish drawing
  void finishDrawing() {
    if (!isTouching) {
      // Add the current state to the undo stack
      undoStack.add(List.from(points));
      print(
          'finishDrawing: Added current state to undoStack. Size of undoStack: ${undoStack.length}');
    }

    // Clear the redo stack since a new action has been performed
    redoStack.clear();
    print(
        'finishDrawing: Cleared redoStack. Size of redoStack: ${redoStack.length}');
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add(List.from(points));
      print(
          'undo: Added current state to redoStack. Size of redoStack: ${redoStack.length}');
      // Pop the last state from the undo stack
      List<Offset> undonePoints = undoStack.removeLast();
      print(
          'undo: Removed last state from undoStack. Size of undoStack: ${undoStack.length}');
      // Add the undone state to the redo stack

      // Set the current points to the undone state
      _points = undonePoints;
      _apiPoints = undonePoints;

      // Notify listeners to repaint the canvas
      notifyListeners();
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      undoStack.add(List.from(points));
      print(
          'redo: Added current state to undoStack. Size of undoStack: ${undoStack.length}');
      // Pop the last state from the redo stack
      List<Offset> redonePoints = redoStack.removeLast();
      print(
          'redo: Removed last state from redoStack. Size of redoStack: ${redoStack.length}');
      // Add the redone state to the undo stack

      // Set the current points to the redone state

      _points = redonePoints;
      _apiPoints = redonePoints;
      // Notify listeners to repaint the canvas
      notifyListeners();
    }
  }

  void resetStacks() {
    undoStack.clear();
    redoStack.clear();
  }
}
