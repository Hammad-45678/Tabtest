import 'dart:async';

import 'dart:typed_data';

import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:picstar/global/exceptions/api_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:picstar/global/widgets/button.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/global/widgets/dialog_box.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/bottomsheet.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/generating_artwork.dart';
import 'package:picstar/pages/ai_replace_screen/widgets/bottom_sheet.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';

import 'package:picstar/pages/object_remover_screen/provider/slider_provider.dart';
import 'package:picstar/pages/object_remover_screen/widgets/brus_size.dart';
import 'package:picstar/pages/object_remover_screen/widgets/show_magnifier.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:picstar/utils/image_save.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

import 'dart:convert';
import 'dart:ui';

import '../../global/widgets/ad_manager.dart';
import '../../global/widgets/ad_widget_banner.dart';
import '../../global/widgets/adloading.dart';
import '../../global/widgets/saving_dialog.dart';

class AiReplace extends StatefulWidget {
  const AiReplace({
    super.key,
  });

  @override
  State<AiReplace> createState() => _AiReplaceState();
}

class _AiReplaceState extends State<AiReplace> {
  var apiUrl;
  final GlobalKey _globalKey = GlobalKey();
  List<PointOrMarker> points = [];
  List<PointOrMarker> apiPoints = [];
  Color currentColor = Colors.red;
  bool _isLoadingAd = false;
  final adManager = AdManager();
  AdManager? _adHelper;
  late final Offset? point;
  late final Offset? point2;
  bool isTouching = false;

  final List<List<PointOrMarker>> undoStack = [];
  final List<List<PointOrMarker>> redoStack = [];

  void undo() {
    if (points.isNotEmpty) {
      setState(() {
        redoStack.add(points.toList());
        points.clear();
        if (undoStack.isNotEmpty) {
          points.addAll(undoStack.removeLast());
        }
      });
    }
  }

  void redo() {
    setState(() {
      if (redoStack.isNotEmpty) {
        undoStack.add(points.toList());
        points.clear();
        points.addAll(redoStack.removeLast());
      }
    });
  }

  void clearAllPoints() {
    points.clear();

    // Call to update the UI if this is part of a Flutter widget
    // setState(() {}); // Uncomment if this method is used within a StatefulWidget
  }

  @override
  void initState() {
    _adHelper = AdManager(
      onAdLoading: () => setState(() => _isLoadingAd = true),
      onAdLoaded: () => setState(() => _isLoadingAd = false),
    );
    super.initState();
  }

  bool isErasing = false;
  Future<void> _saveImage() async {
    ImagePickerProvider imageEditorProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    imageEditorProvider.setLoadingAnimation(true);
    double brushSize = 50.0;
    bool isErasing = false;
    // Create a new PictureRecorder
    ui.PictureRecorder recorder = ui.PictureRecorder();

    // Create a canvas and draw the original image and edited content onto it
    Canvas canvas = Canvas(recorder);
    canvas.drawImage(imageEditorProvider.originalImage!, Offset.zero, Paint());

    ImageEditorPainterDallE painter = ImageEditorPainterDallE(points,
        currentColor, brushSize, isErasing, imageEditorProvider.originalImage!);
    painter.paint(
      canvas,
      Size(imageEditorProvider.originalImage!.width.toDouble(),
          imageEditorProvider.originalImage!.height.toDouble()),
    );

    // Finish recording and obtain the Picture
    ui.Picture picture = recorder.endRecording();

    // Convert the Picture to an Image
    ui.Image finalImage = await picture.toImage(
      imageEditorProvider.originalImage!.width.toInt(),
      imageEditorProvider.originalImage!.height.toInt(),
    );

    // Convert the final image to bytes and save it
    ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List editedImageBytes = byteData!.buffer.asUint8List();

    // Save the image
    // await ImageGallerySaver.saveImage(Uint8List.fromList(editedImageBytes));

    if (mounted) {
      imageEditorProvider.setLoadingAnimation(false);
      _sendApiRequest(
        imageEditorProvider.originalImage!,
        editedImageBytes,
        imageEditorProvider.promptText,
        imageEditorProvider.apiPoints,
        brushSize,
        Size(
          imageEditorProvider.originalImage!.width.toDouble(),
          imageEditorProvider.originalImage!.height.toDouble(),
        ),
      );
    }
    // Navigate to the next screen
  }

  Future<void> _sendApiRequest(
    ui.Image originalImage,
    List<int> editedImageBytes,
    String promptText,
    List<Offset> apiPoints,
    double brushSize,
    Size size,
  ) async {
    ImagePickerProvider imageEditorProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    imageEditorProvider.setLoadingAnimation(true);
    // OpenAI API configuration
    String apiUrl = 'https://lama.cognise.art/api/v2/obj_add';
    Map<String, String> headers = {
      'Authorization': 'token c20427c5b6cbd5cd63096d2777f882fe9b4b1263'
    }; // Replace with your OpenAI API key

    // Ensure that the images are in JPEG format
    List<int> originalImageBytes =
        (await originalImage.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    // Convert the apiPoints to an image
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    // Draw the original image on the canvas
    canvas.drawImage(originalImage, Offset.zero, Paint());

// Draw the black rectangle below the white lines
    Paint backgroundPaint = Paint()..color = Colors.black.withOpacity(1);
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      backgroundPaint,
    );

    // Draw the white lines on the canvas
    // Draw the white lines on the canvas
    Paint whitePaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isPoint && points[i + 1].isPoint) {
        // if (isErasing) {
        //   paint.blendMode = BlendMode.clear;
        // } else {

        // }

        canvas.drawLine(points[i].point!, points[i + 1].point!, whitePaint);
      } else if (points[i].isPoint && !points[i + 1].isPoint) {
        canvas.drawPoints(PointMode.points, [points[i].point!], whitePaint);
      }
    }

    // Convert the recorded picture to an image
    ui.Image editedImage = await recorder.endRecording().toImage(
          originalImage.width,
          originalImage.height,
        );

    // Convert the edited image to bytes
    List<int> editedImageBytes =
        (await editedImage.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();

    // Create a multipart request
    // Create a multipart request for OpenAI API
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add OpenAI API headers
    List<Map<String, String>> formdata = [
      {"key": "time_zone", "value": "Asia/Karachi", "type": "text"},
      {"key": "packagename", "value": "testing", "type": "text"},
      {
        "key": "api_key",
        "value": "cognise-6f15cec1-6686-4ffe-990a-bf6683429651",
        "type": "text",
      },
      {"key": "prompt", "value": promptText, "type": "text"},
      {"key": "watermark", "value": "true", "type": "text"}
    ];

    // Add OpenAI API form data
    for (var field in formdata) {
      request.fields[field['key']!] = field['value']!;
    }
    // Add OpenAI API files
    request.files.addAll([
      http.MultipartFile.fromBytes('image', originalImageBytes,
          filename: 'image_2.jpeg'),
      http.MultipartFile.fromBytes('mask', editedImageBytes,
          filename: 'image_2_mask.jpg'),
    ]);

    try {
      var response = await request.send();

      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Read the response
        var responseBody = await http.Response.fromStream(response);
        print('API Response: ${responseBody.body}');

        // Parse the JSON response
        var jsonResponse = json.decode(responseBody.body);

// Check if the response status is "success"
        if (jsonResponse['status'] == 'success') {
          // Extract the 'data' map from the JSON response
          var data = jsonResponse['data'];
          String? basic;
          // Ensure 'data' is not null and contains 'image'
          if (data != null && data.containsKey('image')) {
            // Get the 'image' key value and convert it to String
            String imageUrl = data['image'].toString();
            basic = "https://lama.cognise.art$imageUrl";
          }

          // Load the processed image from the URL
          ui.Image newImage = await loadImageFromUrl(basic!);

          // Set the new image as the displayed image
          imageEditorProvider.setOriginalImage(newImage);
          clearAllPoints();
          imageEditorProvider.setLoadingAnimation(false);
          imageEditorProvider.clearPoints();
          // Print the API response in the console
        }
        imageEditorProvider.setLoadingAnimation(false);
      } else {
        imageEditorProvider.setLoadingAnimation(false);
        // Handle non-successful response codes

        _showErrorPopup(
          context,
          'Error',
          'API Request failed with status code ${response.statusCode}',
        );
      }
      // main_file.dart
      imageEditorProvider.setLoadingAnimation(false);
// ... (rest of the code)
    } // ... (rest of the code)
    on NetworkUnavailableException catch (e) {
      // Handle specific network unavailable exceptions
      print('$e');
      _showErrorPopup(context, 'Error',
          'Network is unreachable. Please check your internet connection.');
    } on HttpClientException catch (e) {
      // Handle specific HTTP client exceptions
      print('$e');
      _showErrorPopup(
          context, 'Error', 'An error occurred in the HTTP client.');
    } on SocketExceptionWrapper catch (e) {
      // Handle specific socket exceptions
      print('$e');
      if (e.isNetworkUnreachable) {
        _showErrorPopup(context, 'Error',
            'Network is unreachable. Please check your internet connection.');
      } else {
        _showErrorPopup(context, 'Error', 'A network error occurred.');
      }
    } on BadRequestException catch (e) {
      // Handle specific bad request exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'Bad request. Please check your input.');
      }
    } on UnauthorizedException catch (e) {
      // Handle specific unauthorized exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'Unauthorized. Please check your credentials.');
      }
    } on NotFoundException catch (e) {
      // Handle specific not found exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(context, 'Error', 'Resource not found.');
      }
    } on ApiException catch (e) {
      // Handle other generic API exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'An API error occurred: ${e.message}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      if (mounted) {
        _showErrorPopup(context, 'Error', 'An unexpected error occurred.');
      }
    }
  }

  Future<ui.Image> loadImageFromUrl(String imageUrl) async {
    // Load the image using CachedNetworkImage
    var imageProvider = CachedNetworkImageProvider(imageUrl);
    Completer<ui.Image> completer = Completer<ui.Image>();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
        },
      ),
    );

    return completer.future;
  }

  Future<ui.Image> downloadAndDecodeImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;

      // Decode the image bytes
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return frameInfo.image;
    } else {
      throw Exception('Failed to load image from $imageUrl');
    }
  }

  void _showErrorPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isshowDialog = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight / 1.8;
    ImagePickerProvider imageeditorprovider =
        Provider.of<ImagePickerProvider>(context);
    double brushSize = imageeditorprovider.brushSize;
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ui.Image? bgRemovedImage = arguments?['bgRemovedImage'];
    bool _isLoading = false;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(
            onPressed: () {
              Navigator.pop(context);
            },
            height: 50,
            firstleadingImage: Image.asset(
              'assets/icons/btn_back.webp',
              width: 24,
              height: 24,
            ),
            secondleadingImage: Image.asset(
              'assets/icons/frwrd-btn.webp',
              width: 24,
              height: 24,
            ),
            title: Text(
              localeText(
                context,
                'ai_replace',
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.60,
              ),
            ),
            trailingImage: GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: true,
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    SaveImageToGallery.saveNetworkImage2(
                        imageeditorprovider.originalImage!);
                    return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(children: [
                          // Background content
                          BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 20.0,
                                sigmaY:
                                    20.0), // Adjust the sigma values for more/less blur
                            child: const SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          SavingDialog(
                            loadingText:
                                localeText(context, 'saved_to_gallery'),
                            generatingText:
                                localeText(context, 'your_file_has_been'),
                            customLoadingWidget: const Image(
                              image: AssetImage(
                                'assets/icons/check.webp',
                              ),
                              width: 32,
                              height: 32,
                            ),
                            resultText: localeText(context,
                                'successfully_saved_into_your_gallery'),
                          )
                        ]));
                  },
                );

                // Simulate a delay of 2 seconds
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    // Close the loading animation after 2 seconds
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Image.asset(
                'assets/icons/download_purple.webp',
                width: 24,
                height: 24,
              ),
            ),
          ),
          body: Consumer<SliderProvider>(
              builder: (context, sliderProvider, child) {
            return Stack(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          undo();
                        },
                        child: const Image(
                          image: AssetImage('assets/icons/undo.webp'),
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const Image(
                        image: AssetImage('assets/icons/divider_line.webp'),
                        width: 20,
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          redo();
                        },
                        child: const Image(
                          image: AssetImage('assets/icons/redo.webp'),
                          width: 20,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: double.infinity,
                    height: containerHeight,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Consumer<ImagePickerProvider>(
                        builder: (context, imageeditorprovider, child) {
                      return RawGestureDetector(
                        gestures: {
                          PanGestureRecognizer:
                              GestureRecognizerFactoryWithHandlers<
                                  PanGestureRecognizer>(
                            () => PanGestureRecognizer(),
                            (PanGestureRecognizer instance) {
                              instance
                                ..onStart = (details) {
                                  isTouching = true;
                                  imageeditorprovider.setIsTouching(true);
                                }
                                ..onUpdate = (details) {
                                  setState(() {
                                    RenderBox renderBox = _globalKey
                                        .currentContext!
                                        .findRenderObject() as RenderBox;
                                    Offset localPosition = renderBox
                                        .globalToLocal(details.globalPosition);
                                    imageeditorprovider
                                        .updateDragGesturePosition(
                                            details.globalPosition);
                                    // Handle erasing logic
                                    if (isErasing) {
                                      replacePointsInRadius(
                                          localPosition, 40.0);
                                    } else {
                                      points.add(PointOrMarker(localPosition,
                                          localPosition, brushSize));
                                    }
                                  });
                                }
                                ..onEnd = (details) async {
                                  imageeditorprovider.setIsTouching(false);
                                  setState(() {
                                    isTouching = false;
                                    // Handle adding a marker for the end of a stroke based on erasing state
                                    if (!isErasing) {
                                      points.add(PointOrMarker(null, null, 10,
                                          isStartOfLine: true));
                                    }
                                  });
                                  imageeditorprovider.finishDrawing();
                                };
                            },
                          ),
                        },
                        child: ClipRect(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              key: _globalKey,
                              width: imageeditorprovider.originalImage!.width
                                  .toDouble(),
                              height: imageeditorprovider.originalImage!.height
                                  .toDouble(),
                              child: ClipRect(
                                child: CustomPaint(
                                  painter: ImageEditorPainterDallE(
                                    points,
                                    currentColor,
                                    brushSize,
                                    isErasing,
                                    imageeditorprovider.originalImage!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  sliderProvider.isBrushEnabled
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    sliderProvider.toggleSlider();
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/icons/close_icon.webp'),
                                          width: 10,
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(right: 12.0, left: 25),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/icons/divider_small.webp'),
                                    height: 20,
                                    width: 10,
                                  ),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: const SliderThemeData(
                                      trackHeight:
                                          1.0, // Set the height for both active and inactive portions
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8.0),
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max: 500.0,
                                      activeColor: const Color(0xFFD9D9D9),
                                      inactiveColor: const Color(0xFFD9D9D9),
                                      thumbColor: Colors.white,
                                      value: imageeditorprovider.brushSize,
                                      onChanged: (value) {
                                        imageeditorprovider
                                            .updateBrushSize(value);

                                        imageeditorprovider
                                            .setSliderChanging(true);
                                      },
                                      onChangeEnd: (value) {
                                        imageeditorprovider
                                            .setSliderChanging(false);
                                      },
                                    ),
                                  ),
                                )
                              ]),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                isErasing = false;
                                sliderProvider.toggleSlider();
                              },
                              child: Column(
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        'assets/icons/brush_icon.webp'),
                                    width: 23,
                                    height: 23,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    localeText(
                                      context,
                                      'brush',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            InkWell(
                              onTap: () {
                                sliderProvider.toggleSlider();
                                setState(() {
                                  isErasing = true;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        'assets/icons/eraser_icon.webp'),
                                    width: 23,
                                    height: 23,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    localeText(
                                      context,
                                      'erase',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  GlobalButton(
                      buttonText: localeText(
                        context,
                        'replace',
                      ),
                      onPressed: () async {
                        AiReplaceBottomSheet()
                            .showSettingModalBottomSheet(context, () {
                          Navigator.of(context).pop();
                          setState(() {
                            _isshowDialog =
                                true; // Show the GeneratingArtwork widget
                          });
                        });
                        // await _saveImage();
                      })
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Adjust the radius here
                    color: Colors.white, // Optional: Set background color
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // Match the radius with the Container
                    child: const NativeAdWidgetBanner(),
                  ),
                ),
              ),
              if (imageeditorprovider.isSliderChanging)
                const showbrushSize_widget(),
              if (imageeditorprovider.isTouching)
                showmagnifier_widget(
                    dragGesturePosition:
                        imageeditorprovider.dragGesturePosition),
              if (imageeditorprovider.isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black38,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: const LoadingAnimation(
                        loadingText: 'Please Wait..',
                        generatingText: 'AI is generating',
                        customLoadingWidget: SpinKitSpinningLines(
                          color: Colors.white,
                          size: 50,
                        ),
                        resultText: 'the awesome result for you'),
                  ),
                ),
              if (_isshowDialog)
                Center(
                  child: Container(
                      color: Colors.black.withOpacity(0.8),
                      width: double.infinity,
                      height: double.infinity,
                      child: GeneratingArtwork(
                        watchVideoCallback: () async {
                          _adHelper!.createRewardedAd();
                          adManager.showRewardedAd(context, () async {
                            setState(() {
                              _isshowDialog = false;
                            });
                            await _saveImage();
                            setState(() {
                              _isshowDialog = false;
                            });
                          });
                        },
                        premiumCallback: () {},
                      )),
                ),
              if (_isLoadingAd) const Center(child: AdLoading())
            ]);
          })),
    );
  }

  void replacePointsInRadius(Offset point, double radius) {
    for (int i = 0; i < points.length; i++) {
      if (points[i].isPoint && (points[i].point! - point).distance <= radius) {
        points[i] = PointOrMarker(null, null, 10);
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
  final Offset? point;
  final Offset? point2;
  final double? brushSize;
  final bool isStartOfLine; // Offset representing a point, or null as a marker
  PointOrMarker(this.point, this.point2, this.brushSize,
      {this.isStartOfLine = false});

  bool get isPoint => point != null;
}

class ImageEditorPainterDallE extends CustomPainter {
  ui.Image uiImage;
  final List<PointOrMarker> points;

  final Color color;
  final double brushSize;
  final bool isErasing;
  final List<PointOrMarker> undoHistory = [];
  final List<PointOrMarker> redoHistory = [];

  ImageEditorPainterDallE(
    this.points,
    this.color,
    this.brushSize,
    this.isErasing,
    this.uiImage,
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(uiImage, Offset.zero, Paint());

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isPoint && points[i + 1].isPoint) {
        Paint paint = Paint()
          ..color = color.withOpacity(0.1)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i].brushSize ?? brushSize;

        // Use stored brush size

        // Draw a line between consecutive points
        canvas.drawLine(points[i].point!, points[i + 1].point!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Define the _showErrorPopup function
void _showErrorPopup(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogBox(
        title: title,
        message: message,
      );
    },
  );
}
