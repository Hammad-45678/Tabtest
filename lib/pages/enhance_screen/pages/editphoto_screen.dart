import 'dart:io';

import 'dart:ui';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:picstar/global/widgets/image_comparison.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/global/widgets/saving_dialog.dart';
import 'package:picstar/pages/enhance_screen/components/api_client.dart';

import 'package:picstar/pages/enhance_screen/widgets/ai_enhance_button.dart';

import 'package:picstar/pages/enhance_screen/widgets/hd_button.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:picstar/utils/image_save.dart';
import 'package:provider/provider.dart';

import 'package:retrofit/dio.dart';

import '../../../global/exceptions/api_exceptions.dart';
import '../../../global/widgets/ad_widget_media.dart';
import '../../../global/widgets/custom_app_bar_wdiget.dart';
import '../../../revenue_cat/purchase_api.dart';

class EditPhoto extends StatefulWidget {
  EditPhoto({super.key, this.pickedImage, this.isLoading});
  final XFile? pickedImage;
  bool? isLoading;
  @override
  State<EditPhoto> createState() => _EditPhotoState();
}

@override
class _EditPhotoState extends State<EditPhoto> {
  String loadingText = "initilizng..";
  // bool _isLoading = false;
  // bool _imageSaving = false;
  // bool _isHd = false;
  // Uint8List? _apiResponseImage;
  // Uint8List? _apiResponseImageHd;
  @override
  void initState() {
    super.initState();
    bool isHd = false;
    _initializeApiRequest(widget.pickedImage, isHd);
  }

  Future<void> _initializeApiRequest(XFile? pickedImage, bool isHd) async {
    await makeApiRequest(pickedImage!, isHd);
  }

  String? apiResponseImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'edit_photo',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: value.checkIsArOrUr() ? 10 : 18,
                fontWeight: FontWeight.w900,
                letterSpacing: value.checkIsArOrUr() ? 0 : 3.60,
              ),
            );
          }),
          trailingImage: Image.asset(
            'assets/icons/pro.webp',
            width: 67,
            height: 24,
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height / 2.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: apiResponseImage != null
                            ? ImageComparison(
                                image1: widget.pickedImage!,
                                image2: apiResponseImage!)
                            : Image(
                                image: FileImage(
                                    File(widget.pickedImage!.path))))),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 110,

                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF8181FF)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // _sendImageToApi();
                      child: InkWell(
                        onTap: () async {
                          downloadImage(apiResponseImage!)
                              .then((XFile? downloadedImage) {
                            if (downloadedImage != null) {
                              bool isHd = true;

                              // Call the makeApiRequest function with the downloaded XFile
                              makeApiRequest(downloadedImage, isHd);
                            } else {
                              // Handle the case where the downloaded image is null
                              print("Downloaded image is null.");
                            }
                          });
                        },
                        child: const Hd_button(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: InkWell(
                        onTap: () async {
                          // Check if the enhanced image URL is not empty

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
                                          sigmaY:
                                              20.0), // Adjust the sigma values for more/less blur
                                      child: const SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    SavingDialog(
                                      loadingText: localeText(
                                        context,
                                        'saved_to_gallery',
                                      ),
                                      generatingText: localeText(
                                        context,
                                        'your_file_has_been',
                                      ),
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
                          if (apiResponseImage != null) {
                            SaveImageToGallery.downloadAndSaveImage(
                                apiResponseImage!);
                          }
                        },
                        child: Consumer<LocalizationProvider>(builder:
                            (BuildContext context, LocalizationProvider value,
                                Widget? child) {
                          return CustomEnhanceButton(
                            buttonText: localeText(context, 'save'),
                            descriptionText: localeText(
                                context, 'this_action_may_contain_ads'),
                            imagePath: 'assets/icons/download_icon.webp',
                            iconheight: 40,
                            width: 167.76,
                            // height: 13.09,
                            buttonTextFontSize: value.checkIsArOrUr() ? 12 : 20,
                            descriptionTextFontSize:
                                value.checkIsArOrUr() ? 6 : 8,
                          );
                        }),
                      ),
                    )
                  ],
                ),
                Expanded(child: Container()),
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10), // Adjust the radius here
                      color: Colors.white, // Optional: Set background color
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Match the radius with the Container
                      child: const NativeAdWidgetMedia(),
                    ))
              ],
            ),

            // if (_imageSaving)
            //   BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //     child: Container(
            //         color: Colors.black.withOpacity(0.5),
            //         width: double.infinity,
            //         height: MediaQuery.of(context).size.height,
            //         child: Center(
            //             child: LoadingAnimation(
            //           loadingText: localeText(context, 'saved_to_gallery'),
            //           generatingText: localeText(context, 'your_file_has_been'),
            //           customLoadingWidget: const Image(
            //             image: AssetImage(
            //               'assets/icons/check.webp',
            //             ),
            //             width: 32,
            //             height: 32,
            //           ),
            //           resultText: localeText(
            //               context, 'successfully_saved_into_your_gallery'),
            //         ))),
            //   )
            if (widget.isLoading!)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: LoadingAnimation(
                      loadingText: localeText(context, 'please_wait'),
                      generatingText: loadingText,
                      customLoadingWidget: const SpinKitSpinningLines(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              )
          ]),
        ));
  }

  final CancelToken _cancelToken = CancelToken();
  Future<void> makeApiRequest(XFile pickedImage, bool isHd) async {
    try {
      await _prepareForRequest();
      Dio dio = _initializeDio();
      ApiService apiService = ApiService(dio);
      File imageFile = _convertXFileToFile(pickedImage);
      await _processImageUpload(apiService, imageFile, isHd);
    } catch (e) {
      _handleException(e);
    } finally {
      _finalizeRequest();
    }
  }

  Future<void> _prepareForRequest() async {
    await _updateLoadingStateWithDelay("Preparing..");
    await _updateLoadingStateWithDelay("Uploading to Server..");
  }

  Dio _initializeDio() {
    final dio = Dio();
    dio.options.headers['Authorization'] =
        'token c20427c5b6cbd5cd63096d2777f882fe9b4b1263';
    print("Initializing Dio and ApiService...");
    return dio;
  }

  File _convertXFileToFile(XFile pickedImage) {
    print("Converting XFile to File...");
    return File(pickedImage.path);
  }

  Future<void> _processImageUpload(
      ApiService apiService, File imageFile, bool isHd) async {
    await _updateLoadingStateWithDelay("Enhancing Image..");
    HttpResponse<dynamic> response = isHd
        ? await apiService.upscaleImage(imageFile, 'Asia/Karachi', 'testing',
            'cognise-6f15cec1-6686-4ffe-990a-bf6683429651', '2', _cancelToken)
        : await apiService.enhanceImage(imageFile, 'Asia/Karachi', 'testing',
            'cognise-6f15cec1-6686-4ffe-990a-bf6683429651', _cancelToken);
    _handleApiResponse(response);
  }

  Future<void> _updateLoadingStateWithDelay(String message) async {
    updateLoadingState(message, true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      widget.isLoading = true;
    });
  }

  void _handleApiResponse(HttpResponse<dynamic> response) {
    print("Response Status Code: ${response.response.statusCode}");
    print("Response Headers: ${response.response.headers.map}");
    print("Response Body: ${response.response.data}");
    if (response.response.statusCode == 200) {
      _processSuccessResponse(response);
    } else {
      print(
          "API request failed with status code: ${response.response.statusCode}");
    }
  }

  void _processSuccessResponse(HttpResponse<dynamic> response) {
    var responseBody = response.data;
    if (responseBody != null && responseBody is Map<String, dynamic>) {
      var data = responseBody['data'];
      if (data != null &&
          data is Map<String, dynamic> &&
          data.containsKey('image')) {
        String imageUrl = data['image'].toString();
        apiResponseImage = "https://lama.cognise.art$imageUrl";
        print("Image URL: $apiResponseImage");
      }
    }
  }

  void _handleException(dynamic e) {
    print('Error: $e');
    String errorMessage = 'An error occurred.';
    if (e is NetworkUnavailableException) {
      errorMessage =
          'Network is unreachable. Please check your internet connection.';
    } else if (e is HttpClientException) {
      errorMessage = 'An error occurred in the HTTP client.';
    } else if (e is SocketExceptionWrapper) {
      errorMessage = e.isNetworkUnreachable
          ? 'Network is unreachable. Please check your internet connection.'
          : 'A network error occurred.';
    } else if (e is BadRequestException) {
      errorMessage = 'Bad request. Please check your input.';
    } else if (e is UnauthorizedException) {
      errorMessage = 'Unauthorized. Please check your credentials.';
    } else if (e is NotFoundException) {
      errorMessage = 'Resource not found.';
    } else if (e is ApiException) {
      errorMessage = 'An API error occurred: ${e.message}';
    } else {
      errorMessage = 'An unexpected error occurred: $e';
    }
    if (mounted) {
      _showErrorPopup(context, 'Error', errorMessage);
    }
  }

  void _finalizeRequest() {
    if (mounted) {
      setState(() {
        widget.isLoading = false;
      });
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

  void updateLoadingState(String text, bool loading) {
    setState(() {
      loadingText = text;
      widget.isLoading = loading;
    });
  }

  @override
  void dispose() {
    // Set _isLoading to false when the widget is disposed

    widget.isLoading = false;

    // Dispose any other resources or controllers if needed
    super.dispose();
  }

  Future<XFile?> downloadImage(String imageUrl) async {
    try {
      setState(() {
        widget.isLoading = true;
      });
      // Use dio package for handling HTTP requests
      var dio = Dio();

      // Define a directory to store the downloaded image
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/downloaded_image.jpg';

      // Send a GET request to download the image
      await dio.download(imageUrl, filePath);
      setState(() {
        widget.isLoading = false;
      });
      // Return the downloaded image as XFile
      return XFile(filePath);
    } catch (e) {
      // Handle any errors that might occur during the download
      print('Error downloading image: $e');

      return null;
    }
  }
}
