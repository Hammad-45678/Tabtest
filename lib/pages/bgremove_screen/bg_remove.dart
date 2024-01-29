import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:picstar/global/widgets/button.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/pages/bgremove_screen/widgets/text_painter.dart';

import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';
import 'package:picstar/translation_manager/language_constants.dart';

import 'package:picstar/utils/image_save.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:text_editor/text_editor.dart';

import '../../global/widgets/ad_widget_banner.dart';
import '../../global/widgets/saving_dialog.dart';

class BgRemove extends StatefulWidget {
  const BgRemove({super.key});

  @override
  State<BgRemove> createState() => _BgRemoveState();
}

List<Color> myColors = <Color>[
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.indigo,
];
Color primaryColor = myColors[0];

class _BgRemoveState extends State<BgRemove> {
  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = const TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Billabong',
  );
  String _text = '';
  TextAlign _textAlign = TextAlign.center;
  final ScreenshotController _controller = ScreenshotController();
  GlobalKey screenKey = GlobalKey();
  List<Map<String, dynamic>> dataList = [
    {'image': 'assets/images/brownBg.webp', 'text': 'Bg1'},
    {'image': 'assets/icons/bg2.webp', 'text': 'Bg2'},
    {'image': 'assets/icons/bg3.webp', 'text': 'Bg3'},
    {'image': 'assets/icons/bg4.webp', 'text': 'Bg4'},
    {'image': 'assets/icons/bg5.webp', 'text': 'Bg5'},
    {'image': 'assets/icons/gallery.webp', 'text': 'Gallery'},
  ];
  List<Map<String, dynamic>> dataList2 = [
    {'image': 'assets/images/brownBg.webp', 'text': 'Color'},
    {'image': 'assets/images/pattern1.webp', 'text': 'Pattern'},
    {'image': 'assets/images/pattern2.webp', 'text': 'Frame'},
    {'image': 'assets/images/pattern3.webp', 'text': 'Pattern 02'},
    {'image': 'assets/images/pattern4.webp', 'text': 'Pattern 03'},
  ];
  Uint8List? textImage;
  Uint8List? croppedImage;
  double removedImageLeft = 0.0;
  double removedImageTop = 0.0;
  double removedTextImageLeft = 0.0;
  double removedTextImageTop = 0.0;
  GlobalKey stackKey = GlobalKey();
  Uint8List? backgroundImage;
  double selectedAspectRatio = 1.5;
  bool isCropEnabled = false;
  bool isLoading = false;
  double removedImageScale = 1.0;
  double removedTextImageScale = 1.0;
  bool isBgRemoveEnabled = false;
  bool isColorRowEnabled = false;
  bool isTextWidgetVisible = false;
  Uint8List? initialimage;
  Uint8List? capturedImage;

  bool showTextEditor = false;
  bool isFilterEnabled = false;
  String? foregroundImage;

  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  void onAspectRatioSelected(double aspectRatio) {
    setState(() {
      selectedAspectRatio = aspectRatio;
      controller.aspectRatio = aspectRatio;
      controller.aspectRatio =
          selectedAspectRatio == -1 ? null : selectedAspectRatio;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      foregroundImage = (ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?)?['bgRemovedImage'];
      setState(() {}); // Trigger a rebuild if necessary
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              'edit_photo',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.60,
            ),
          ),
          trailingImage: Image.asset(
            'assets/icons/pro.webp',
            width: 67,
            height: 24,
          ),
        ),
        body: Stack(children: [
          Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              RepaintBoundary(
                key: stackKey,
                child: isCropEnabled
                    ? SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CropImage(
                            controller: controller,
                            image: capturedImage != null
                                ? Image.memory(
                                    capturedImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    foregroundImage!,
                                    fit: BoxFit.cover,
                                  ),
                            paddingSize: 0,
                            alwaysMove: true,
                          ),
                        ),
                      )
                    : isFilterEnabled
                        ? SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2,
                            child: ColorFiltered(
                              colorFilter:
                                  ColorFilter.mode(primaryColor, BlendMode.hue),
                              child: foregroundImage != null
                                  ? Image.network(
                                      foregroundImage!,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.memory(
                                      capturedImage!,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          )
                        : Screenshot(
                            key: screenKey,
                            controller: _controller,
                            child: ClipRect(
                              child: SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 2,
                                child: Stack(children: [
                                  if (backgroundImage != null)
                                    Image.memory(
                                      backgroundImage!,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  if (capturedImage != null)
                                    Image.memory(
                                      capturedImage!,
                                      fit: BoxFit.fill,
                                    ),
                                  if (foregroundImage != null)
                                    ZoomableImage(
                                      imageUrl: foregroundImage!,
                                    ),
                                  if (croppedImage != null)
                                    Image.memory(
                                      croppedImage!,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  Center(
                                    child: ZoomableText(
                                      textAlign: _textAlign,
                                      text: _text,
                                      textStyle: _textStyle,
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ),
              ),
              const SizedBox(
                height: 10,
              ),
              //show crop_edit_option

              isCropEnabled
                  ? buildCropRow()

                  //show bg replace row
                  : isBgRemoveEnabled
                      ? buildBgRemoveRow()
                      : isFilterEnabled
                          ? buildFilterRow()

                          //show main rwo
                          : buildMainRow(),

              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Visibility(
                    visible: !isCropEnabled &&
                        !isBgRemoveEnabled &&
                        !isFilterEnabled,
                    child: GlobalButton(
                        buttonText: localeText(
                          context,
                          'save',
                        ),
                        onPressed: () async {
                          SaveImageToGallery saveImageToGallery =
                              SaveImageToGallery();

                          Uint8List? image = await _controller.capture();
                          if (image != null)
                            await saveImageToGallery.saveNetworkImage(image);

                          showDialog(
                            barrierDismissible: true,
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              if (croppedImage != null) {
                                SaveImageToGallery saveImageToGallery =
                                    SaveImageToGallery();

                                // Now call the instance method on the created object

                                saveImageToGallery
                                    .saveNetworkImage(croppedImage!);
                              }

                              if (capturedImage != null) {
                                SaveImageToGallery saveImageToGallery =
                                    SaveImageToGallery();
                                saveImageToGallery
                                    .saveNetworkImage(capturedImage!);
                              } else {
                                SaveImageToGallery.downloadAndSaveImage(
                                    foregroundImage!);
                              }
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
                                      loadingText: localeText(
                                          context, 'saved_to_gallery'),
                                      generatingText: localeText(
                                          context, 'your_file_has_been'),
                                      customLoadingWidget: const Image(
                                        image: AssetImage(
                                          'assets/icons/check.webp',
                                        ),
                                        width: 32,
                                        height: 32,
                                      ),
                                      resultText: localeText(context,
                                          'successfully_saved_into_your_gallery'),
                                    ),
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
                        }),
                  )),
            ],
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
          if (isLoading)
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.8),
                  width: double.infinity,
                  child: Center(
                      child: LoadingAnimation(
                    loadingText: localeText(context, 'please_wait'),
                    generatingText: localeText(context, 'ai_is_generating'),
                    customLoadingWidget: const SpinKitSpinningLines(
                      color: Colors.white,
                      size: 50,
                    ),
                    resultText:
                        localeText(context, 'the_awsome_result_for_you'),
                  ))),
            ),
        ]),
      ),
    );
  }

  Widget buildFilterRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isFilterEnabled = false;
                    });
                  },
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/icons/close_icon.webp'),
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Image(
                  image: AssetImage('assets/icons/divider_small.webp'),
                  width: 2,
                  height: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.59,
                    height: 50, // Set a fixed height for the ListView
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: myColors.length,
                      itemBuilder: (context, index) {
                        var myColor = myColors[index];
                        return buildIconBtn(myColor);
                      },
                    ),
                  ),
                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      backgroundImage = null;
                      foregroundImage = null;

                      croppedImage = null;
                      setState(() {
                        saveImage();
                        isFilterEnabled = false;
                      });
                    },
                    child: const SizedBox(
                      width: 25,
                      height: 25,
                      child: Column(
                        children: [
                          Center(
                            child: Icon(
                              (Icons.check_sharp),
                              size: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //another
              ]),
        )
      ],
    );
  }

  Widget buildIconBtn(Color myColor) => Container(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  primaryColor = myColor;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myColor.withOpacity(0.5),
                    BlendMode.srcATop,
                  ),
                  child: capturedImage != null || foregroundImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: capturedImage != null
                              ? Image.memory(
                                  capturedImage!,
                                  fit: BoxFit.contain,
                                )
                              : Image.network(
                                  foregroundImage!, // Replace with your image data
                                  fit: BoxFit.cover,
                                ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            )
          ],
        ),
      );
  Widget buildCropRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  isCropEnabled = false;
                });
              },
              child: const SizedBox(
                width: 25,
                height: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/icons/close_icon.webp'),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Image(
              image: AssetImage('assets/icons/divider_small.webp'),
              width: 2,
              height: 25,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () => onAspectRatioSelected(-1.0),
              child: const Image(
                image: AssetImage('assets/icons/crop5.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              localeText(
                context,
                'custom',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () => onAspectRatioSelected(2.0),
              child: const Image(
                image: AssetImage('assets/icons/crop1.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '2:1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () => onAspectRatioSelected(1 / 2),
              child: const Image(
                image: AssetImage('assets/icons/crop2.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '1:2',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () => onAspectRatioSelected(4.0 / 3.0),
              child: const Image(
                image: AssetImage('assets/icons/crop3.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '4:3',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () => onAspectRatioSelected(16.0 / 9.0),
              child: const Image(
                image: AssetImage('assets/icons/crop4.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              '16:9',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Column(
          children: [
            SizedBox(
              width: 2,
              height: 25,
              child: Image(
                  width: 2,
                  height: 25,
                  image: AssetImage('assets/icons/divider_small.webp')),
            )
          ],
        ),
        InkWell(
          onTap: () async {
            backgroundImage = null;
            foregroundImage = null;
            capturedImage = null;
            isCropEnabled = false;
            ui.Image bitmap = await controller.croppedBitmap();
            ByteData? data =
                await bitmap.toByteData(format: ImageByteFormat.png);
            Uint8List bytes = data!.buffer.asUint8List();

            setState(() {
              croppedImage = bytes;
            });
          },
          child: const SizedBox(
            width: 20,
            height: 20,
            child: Column(
              children: [
                Icon(
                  (Icons.check_sharp),
                  size: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBgRemoveRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                backgroundImage = null;
                setState(() {
                  isBgRemoveEnabled = false;
                });
              },
              child: const SizedBox(
                width: 25,
                height: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/icons/close_icon.webp'),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Image(
              image: AssetImage('assets/icons/divider_small.webp'),
              width: 2,
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(dataList.length, (index) {
                      Map<String, dynamic> data = dataList[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToScreen(data['text']);
                        },
                        child: Container(
                          width: 40,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(data['image']),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                data['text'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  saveImage();
                  isBgRemoveEnabled = false;
                  backgroundImage = null;
                  foregroundImage = null;
                });
              },
              child: const SizedBox(
                width: 25,
                height: 25,
                child: Column(
                  children: [
                    Icon(
                      (Icons.check_sharp),
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            //another
          ]),
    );
  }

  Widget buildMainRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isBgRemoveEnabled = true;
            });
          },
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/icons/bg_change.webp'),
                width: 25,
                height: 25,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                localeText(
                  context,
                  'background_change',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isFilterEnabled = true;
            });
          },
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/icons/add_filter.webp'),
                width: 25,
                height: 25,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                localeText(
                  context,
                  'add_filter',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isCropEnabled = true;
                });
              },
              child: const Image(
                image: AssetImage('assets/icons/crop.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              localeText(
                context,
                'crop',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        GestureDetector(
          onTap: () => _tapHandler(_text, _textStyle, _textAlign),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/icons/add_text.webp'),
                width: 25,
                height: 25,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                localeText(
                  context,
                  'add_text',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildColorRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  isBgRemoveEnabled = false;
                });
              },
              child: const SizedBox(
                width: 25,
                height: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/icons/close_icon.webp'),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Image(
              image: AssetImage('assets/icons/divider_small.webp'),
              width: 2,
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(dataList2.length, (index) {
                      Map<String, dynamic> data = dataList[index];
                      return Container(
                        width: 40,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(data['image']),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              data['text'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Column(
                  children: [
                    Icon(
                      (Icons.check_sharp),
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            //another
          ]),
    );
  }

  void saveImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Create a boundary key
      GlobalKey boundaryKey = stackKey;

      // Find the render object of the boundary
      // ignore: use_build_context_synchronously
      RenderRepaintBoundary boundary = boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Capture the image
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0); // You can adjust the pixel ratio as needed
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      capturedImage = byteData!.buffer.asUint8List();

      // Save the image to the gallery
      // await ImageGallerySaver.saveImage(capturedImage!);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during image saving: $e");
      // Handle error
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _navigateToScreen(String screenName) async {
    ImagePickerProvider imageEditorProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    // Implement the navigation logic based on the screenName
    // You can use a switch statement or other logic to determine which screen to navigate to
    switch (screenName) {
      case 'Bg1':
        String assetPath = 'assets/images/bg1.webp';
        ByteData data = await rootBundle.load(assetPath);
        setState(() {
          backgroundImage = data.buffer.asUint8List();
        });
        // Navigate to the Color screen
        break;
      case 'Bg2':
        String assetPath = 'assets/images/bg2.webp';
        ByteData data = await rootBundle.load(assetPath);
        setState(() {
          backgroundImage = data.buffer.asUint8List();
        });
        // Navigate to the Color screen
        break;
      case 'Bg3':
        String assetPath = 'assets/images/bg3.webp';
        ByteData data = await rootBundle.load(assetPath);
        setState(() {
          backgroundImage = data.buffer.asUint8List();
        });
        // Navigate to the Color screen
        break;
      case 'Bg4':
        String assetPath = 'assets/images/bg4.webp';
        ByteData data = await rootBundle.load(assetPath);
        setState(() {
          backgroundImage = data.buffer.asUint8List();
        });
        // Navigate to the Color screen
        break;

      case 'Bg5':
        String assetPath = 'assets/images/bg5.webp';
        ByteData data = await rootBundle.load(assetPath);
        setState(() {
          backgroundImage = data.buffer.asUint8List();
        });
        // Navigate to the Color screen
        break;
      case 'Gallery':
        bool imaagpeicke = await imageEditorProvider.getImageFromGallery();
        if (imaagpeicke) {
          Uint8List fileBytes =
              File(imageEditorProvider.image!.path).readAsBytesSync();
          setState(() {
            backgroundImage = fileBytes;
          });
        }

        // Navigate to the Pattern screen
        break;
      // Add cases for other screens
    }
  }

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      barrierColor: Colors.black87,
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Scaffold(
          backgroundColor: const ui.Color.fromRGBO(0, 0, 0, 0),
          body: SafeArea(
            // top: false,
            child: TextEditor(
              backgroundColor: Colors.transparent,
              fonts: fonts,
              text: text,
              textStyle: textStyle,
              textAlingment: textAlign,
              minFontSize: 10,
              // paletteColors: [
              //   Colors.black,
              //   Colors.white,
              //   Colors.blue,
              //   Colors.red,
              //   Colors.green,
              //   Colors.yellow,
              //   Colors.pink,
              //   Colors.cyanAccent,
              // ],
              // decoration: EditorDecoration(
              //   textBackground: TextBackgroundDecoration(
              //     disable: Text('Disable'),
              //     enable: Text('Enable'),
              //   ),
              //   doneButton: Icon(Icons.close, color: Colors.white),
              //   fontFamily: Icon(Icons.title, color: Colors.white),
              //   colorPalette: Icon(Icons.palette, color: Colors.white),
              //   alignment: AlignmentDecoration(
              //     left: Text(
              //       'left',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     center: Text(
              //       'center',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     right: Text(
              //       'right',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              onEditCompleted: (style, align, text) {
                setState(() {
                  _text = text;
                  _textStyle = style;
                  _textAlign = align;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  ZoomableImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _position = Offset.zero;
  Offset _startPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        _startPosition = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
          _position += (details.focalPoint - _startPosition) / _scale;
          _startPosition = details.focalPoint;
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = 1.0;
      },
      child: Transform(
        transform: Matrix4.identity()
          ..scale(_scale, _scale)
          ..translate(_position.dx, _position.dy),
        alignment: FractionalOffset.center,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ZoomableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;

  ZoomableText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  _ZoomableTextState createState() => _ZoomableTextState();
}

class _ZoomableTextState extends State<ZoomableText> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _position = Offset.zero;
  Offset _startPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        _startPosition = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
          _position += (details.focalPoint - _startPosition) / _scale;
          _startPosition = details.focalPoint;
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = 1.0;
      },
      child: Transform(
        transform: Matrix4.identity()
          ..scale(_scale, _scale)
          ..translate(_position.dx, _position.dy),
        alignment: FractionalOffset.center,
        child: Text(
          widget.text,
          style: widget.textStyle,
          textAlign: widget.textAlign,
        ),
      ),
    );
  }
}
