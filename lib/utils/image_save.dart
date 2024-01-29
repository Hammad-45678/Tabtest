// image_utils.dart

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveImageToGallery {
  Future<void> saveNetworkImage(Uint8List imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selectedValue = prefs.getInt('selectedFormat') ?? 1;

    // Check the selected format and determine the file extension
    late String fileExtension;
    if (selectedValue == 1) {
      fileExtension = "jpg";
    } else if (selectedValue == 2) {
      fileExtension = "png";
    } else if (selectedValue == 3) {
      fileExtension = "webp";
    } else {
      print("Invalid selectedFormat: $selectedValue");
      return;
    }
    Directory? directory;
    // Save to gallery
    if (!(await Permission.storage.isGranted)) {
      await Permission.storage.request();

      if (!(await Permission.storage.isGranted)) {
        print("Permission not granted. Unable to save image to gallery.");
        return;
      }
    }
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      // Save to application folder
      directory = await getExternalStorageDirectory();
    }
    String fileName =
        "image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension"; // Use jpg as the default extension
    File file = File("${directory!.path}/$fileName");
    await file.writeAsBytes(imageBytes);

    // Save to gallery with the correct extension
    await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);

    print("Image saved to gallery: ${file.path}");
  }

  static Future<void> saveNetworkImage2(Image image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selectedValue = prefs.getInt('selectedFormat') ?? 1;

    // Check the selected format and determine the file extension
    late String fileExtension;
    if (selectedValue == 1) {
      fileExtension = "jpg";
    } else if (selectedValue == 2) {
      fileExtension = "png";
    } else if (selectedValue == 3) {
      fileExtension = "webp";
    } else {
      print("Invalid selectedFormat: $selectedValue");
      return;
    }

    // Request storage permission if not granted
    if (!(await Permission.storage.isGranted)) {
      await Permission.storage.request();
    }
    Directory? directory;
    // Convert Image to Uint8List
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Save to application folder
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    String fileName =
        "image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension";
    File file = File("${directory!.path}/$fileName");
    await file.writeAsBytes(Uint8List.fromList(pngBytes));

    print("Image saved to application folder: ${file.path}");

    // Save to gallery with the correct extension
    final galleryFile = File("${directory.path}/temp_image.$fileExtension");
    await galleryFile.writeAsBytes(Uint8List.fromList(pngBytes));
    await ImageGallerySaver.saveFile(galleryFile.path, isReturnPathOfIOS: true);

    // Now you can use the selectedValue as needed
    print("Selected Format: $selectedValue");
  }

  static Future<void> downloadAndSaveImage(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? selectedValue = prefs.getInt('selectedFormat');

    String fileExtension;
    switch (selectedValue) {
      case 1:
        fileExtension = "jpg";
        break;
      case 2:
        fileExtension = "png";
        break;
      case 3:
        fileExtension = "webp";
        break;
      default:
        print("Invalid selectedFormat: $selectedValue");
        return;
    }

    print("File extension for saving: $fileExtension"); // Debugging line

    Dio dio = Dio();
    Directory tempDir = await getTemporaryDirectory();
    String fileName = "downloaded_image.$fileExtension";
    String filePath = '${tempDir.path}/$fileName';

    print("Downloading to: $filePath"); // Debugging line

    await dio.download(url, filePath);

    File imageFile = File(filePath);
    Uint8List bytes = await imageFile.readAsBytes();

    print("Saving image to gallery..."); // Debugging line

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(bytes),
      quality: 60,
      name: "gallery_saved_$fileName",
    );

    print("Image saved to gallery: $result");
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (!(await permission.isGranted)) {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
    return true;
  }
}
