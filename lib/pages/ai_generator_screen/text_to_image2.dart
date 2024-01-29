import 'dart:convert';
import 'dart:io';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:path_provider/path_provider.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/global/widgets/loading_animation.dart';

import 'package:http/http.dart' as http;
import 'package:picstar/shared/routes/routes.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:picstar/utils/image_save.dart';
import 'package:provider/provider.dart';

import '../../global/widgets/ad_manager.dart';
import '../../global/widgets/adloading.dart';
import '../../global/widgets/saving_dialog.dart';
import 'apiclient/ai_generator/apiclient.dart';

class Text2ImageScreen2 extends StatefulWidget {
  String imageUrl1;
  String imageUrl2;
  String imageUrl3;
  String imageUrl4;
  String enteredText;
  String? samplingMethod;
  String? negativePrompt;
  String? seed;
  double? slidervalue;
  int? selectedStylesid;

  String? selectedSize;
  Text2ImageScreen2(
      {super.key,
      required this.imageUrl1,
      required this.imageUrl2,
      required this.imageUrl3,
      required this.imageUrl4,
      required this.enteredText,
      required this.samplingMethod,
      required this.negativePrompt,
      required this.seed,
      required this.slidervalue,
      required this.selectedStylesid,
      required this.selectedSize});

  @override
  State<Text2ImageScreen2> createState() => _Text2ImageScreen2State();
}

String? generatingText;
bool isTapped = false;
int selectedIndex = 0;
late TextEditingController _textController2;
bool isLoading = false;
String? _apiResponseImageHd;
String? loadingText = "Enhancing Image..";

class _Text2ImageScreen2State extends State<Text2ImageScreen2> {
  late String anotherString;
  bool _isLoadingAd = false;
  final adManager = AdManager();
  AdManager? _adHelper;
  @override
  void initState() {
    super.initState();
    _adHelper = AdManager(
      onAdLoading: () => setState(() => _isLoadingAd = true),
      onAdLoaded: () => setState(() => _isLoadingAd = false),
    );
    _textController2 = TextEditingController(text: widget.enteredText);
    // Assign the value of imageUrl1 to anotherString
    anotherString = widget.imageUrl1;
  }

  @override
  void dispose() {
    // Dispose of the controller to prevent memory leaks
    //_textController2.dispose();
    super.dispose();
  }

  void updateLoadingText(String statusText) {
    setState(() {
      loadingText =
          statusText; // 'loadingText' is a String variable that holds the current loading text.
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back press event here
        Navigator.pushNamed(context, RouteHelper.aiGenerator);
        return true; // Return true to allow popping the screen
      },
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
          title: Consumer<LocalizationProvider>(builder: (BuildContext context,
              LocalizationProvider value, Widget? child) {
            return Text(
                localeText(
                  context,
                  'text_to_image',
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: value.checkIsArOrUr() ? 14 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: value.checkIsArOrUr() ? 0 : 0.60,
                ));
          }),
          trailingImage: Image.asset(
            'assets/icons/pro.webp',
            width: 67,
            height: 24,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 320,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl1,
                        placeholder: (context, url) => const Center(
                          child: SpinKitSpinningLines(color: Color(0xFF8181FF)),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection:
                            Axis.horizontal, // Horizontal scrolling
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          // Use different images for each container
                          List<String> imagePaths = [
                            anotherString,
                            widget.imageUrl2,
                            widget.imageUrl3,
                            widget.imageUrl4,
                          ];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // Swap the tapped image with the one in widget.imageUrl1
                                String temp = widget.imageUrl1;

                                widget.imageUrl1 = imagePaths[index];
                                imagePaths[index] = temp;

                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(
                                  8.0), // Adjust the margin as needed
                              width: 70,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? const Color(0xFF8181FF)
                                      : Colors
                                          .transparent, // Border color for unselected containers
                                  width: 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: imagePaths[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SpinKitSpinningLines(
                                        color: Color(0xFF8181FF)),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _downloadImage(widget.imageUrl1, context);
                            },
                            child: Container(
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(-1.00, 0.00),
                                    end: Alignment(1, 0),
                                    colors: [
                                      Color(0xFF8181FF),
                                      Color(0xFFC74EC8)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7.0, horizontal: 5),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/download_icon.webp'),
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      child: Consumer<LocalizationProvider>(
                                          builder: (BuildContext context,
                                              LocalizationProvider value,
                                              Widget? child) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                localeText(
                                                  context,
                                                  'save',
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      value.checkIsArOrUr()
                                                          ? 10
                                                          : 14,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing:
                                                      value.checkIsArOrUr()
                                                          ? 0
                                                          : 0,
                                                )),
                                            Text(
                                                localeText(
                                                  context,
                                                  'this_action_may_contain_ads',
                                                ),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      value.checkIsArOrUr()
                                                          ? 5
                                                          : 9,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing:
                                                      value.checkIsArOrUr()
                                                          ? 0
                                                          : 0,
                                                )),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF8181FF)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await _downloadImageAndSendToApi(
                                    widget.imageUrl1);
                                Navigator.pushNamed(
                                  context,
                                  RouteHelper.showEnhanced,
                                  arguments: _apiResponseImageHd,
                                );
                              },
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 5),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/premium_icon.webp'),
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Consumer<LocalizationProvider>(
                                        builder: (BuildContext context,
                                            LocalizationProvider value,
                                            Widget? child) {
                                      return Column(
                                        children: [
                                          Text(
                                              localeText(
                                                context,
                                                'high_quality',
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: value.checkIsArOrUr()
                                                    ? 10
                                                    : 12,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing:
                                                    value.checkIsArOrUr()
                                                        ? 0
                                                        : 0,
                                              )),
                                          Text(
                                              localeText(
                                                context,
                                                'get_all_features_unlocked',
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: value.checkIsArOrUr()
                                                    ? 6
                                                    : 8,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing:
                                                    value.checkIsArOrUr()
                                                        ? 0
                                                        : 0,
                                              )),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          localeText(
                            context,
                            'your_prompt',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0,
                            letterSpacing: 0.42,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 0),
                        child: TextField(
                          controller: _textController2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.30,
                          ),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: localeText(context, 'type_here'),
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          _adHelper!.createRewardedAd();
                          adManager.showRewardedAd(context, () async {
                            setState(() {
                              isLoading = true;
                            });
                            ApiRequests apiRequests = ApiRequests();
                            await apiRequests.sendRequest(
                                context,
                                _textController2,
                                widget.samplingMethod,
                                widget.negativePrompt,
                                widget.seed,
                                widget.slidervalue,
                                widget.selectedStylesid,
                                widget.selectedSize,
                                updateLoadingText);
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: const GenerateButton())
                  ]),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                    color: Colors.black.withOpacity(0.8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: LoadingAnimation(
                      loadingText: localeText(context, 'please_wait'),
                      generatingText: loadingText!,
                      customLoadingWidget: const SpinKitSpinningLines(
                        color: Colors.white,
                        size: 50,
                      ),
                    )),
              ),
            if (_isLoadingAd)
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Center(child: AdLoading()),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Future<void> _downloadImageAndSendToApi(String imageUrl) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Download the image
      var response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the temporary directory
        Directory tempDir = await getTemporaryDirectory();

        // Create a temporary file in the temporary directory
        File imageFile = File('${tempDir.path}/image.jpg');

        // Write the image content to the file
        await imageFile.writeAsBytes(response.bodyBytes);

        // Prepare the request body
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://lama.cognise.art/api/v2/img_upscale'),
        )
          ..headers['Authorization'] =
              'token c20427c5b6cbd5cd63096d2777f882fe9b4b1263'
          ..fields['time_zone'] = 'Asia/Karachi'
          ..fields['upscale'] = '4'
          ..fields['packagename'] = 'testing'
          ..fields['api_key'] = 'cognise-6f15cec1-6686-4ffe-990a-bf6683429651'
          ..files
              .add(await http.MultipartFile.fromPath('image', imageFile.path));

        // Send the request
        var apiResponse = await request.send();

        // Check if the request was successful
        if (apiResponse.statusCode == 200) {
          // Parse the JSON response
          var jsonResponse =
              json.decode(await apiResponse.stream.bytesToString());

          // Check if the response status is "success"
          if (jsonResponse['status'] == 'success') {
            var data = jsonResponse['data'];
            // Extract the image URL from the response data
            String? basic;
            if (data != null && data.containsKey('image')) {
              // Get the 'image' key value and convert it to String
              String imageUrl = data['image'].toString();
              basic = "https://lama.cognise.art$imageUrl";
            }

            setState(() {
              _apiResponseImageHd = basic;
            });
          } else {
            // Handle API error if needed
            print('API error: ${jsonResponse['message']}');
          }
        } else {
          // Handle HTTP error if needed
          print('HTTP error: ${apiResponse.reasonPhrase}');
        }
      } else {
        // Handle image download error
        print('Image download error: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _downloadImage(String url, BuildContext context) async {
    // Display a snackbar to indicate that the image has been saved
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(children: [
              // Background content
              BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0), // Adjust the sigma values for more/less blur
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              const SavingDialog(
                loadingText: 'Saved to Gallery',
                generatingText: 'Your file has been',
                customLoadingWidget: Image(
                  image: AssetImage(
                    'assets/icons/check.webp',
                  ),
                  width: 32,
                  height: 32,
                ),
                resultText: 'successfully saved into your gallery.',
              )
            ]));
      },
    );
    SaveImageToGallery.downloadAndSaveImage(url);
  }
}

class GenerateButton extends StatelessWidget {
  const GenerateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF8181FF)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
            child: Image(
              image: AssetImage('assets/icons/video_icon.webp'),
              width: 27,
              height: 27,
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 10),
            child: Consumer<LocalizationProvider>(builder:
                (BuildContext context, LocalizationProvider value,
                    Widget? child) {
              return Column(
                children: [
                  Text(
                      localeText(
                        context,
                        'generate',
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: value.checkIsArOrUr() ? 12 : 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: value.checkIsArOrUr() ? 0 : 0.60,
                      )),
                  Text(
                      localeText(
                        context,
                        'this_action_may_contain_ads',
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: value.checkIsArOrUr() ? 6 : 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: value.checkIsArOrUr() ? 0 : 0.60,
                      )),
                ],
              );
            }),
          ),
          Expanded(child: Container()),
          const SizedBox(
            height: 27,
            width: 27,
          )
        ],
      ),
    );
  }
}
