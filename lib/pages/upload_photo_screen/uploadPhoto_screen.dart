import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/pages/bgremove_screen/services/api_client.dart';
import 'package:picstar/pages/bgremove_screen/services/api_service.dart';
import 'package:picstar/pages/enhance_screen/components/advanced_settings.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';
import 'package:picstar/pages/enhance_screen/widgets/custom_button.dart';
import 'package:picstar/shared/routes/routes.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:provider/provider.dart';

import '../../global/exceptions/api_exceptions.dart';
import '../../global/widgets/ad_widget.dart';
import '../../global/widgets/ad_widget_media.dart';
import '../../shared/constants/ad_constants.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});
  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

bool _isLoading = false;
NativeAd? nativeAd;
bool isNativeAdLoaded = false;
Uint8List? removedBackgroundImage;
bool isIOS = Platform.isIOS;
String loadingText = "Initializing..";

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  @override
  void dispose() {
    // Set _isLoading to false when the widget is disposed
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel("The user has left the page"); // Cancel the request
    }

    _isLoading = false;

    // Dispose any other resources or controllers if needed
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load the ad if it has not been loaded or disposed
    // if (nativeAd == null) {
    //   loadNativeAd();
    // }
  }

  // void loadNativeAd() {
  //   nativeAd = NativeAd(
  //     adUnitId: Platform.isIOS
  //         ? AdConstants.iosAdUnitId // Use iOS ad unit ID
  //         : AdConstants.androidAdUnitId, // Use Android ad unit ID
  //     factoryId: "listTileMedia",
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           isNativeAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         nativeAd!.dispose();
  //       },
  //     ),
  //     request: const AdRequest(),
  //   );
  //   nativeAd!.load();
  // }

  // void loadNativeAd() {
  //   nativeAd = NativeAd(
  //     adUnitId: Platform.isIOS
  //         ? AdConstants.iosAdUnitId // Use iOS ad unit ID
  //         : AdConstants.androidAdUnitId, // Use Android ad unit ID
  //     factoryId: "listTileMedium2",
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           isNativeAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         nativeAd!.dispose();
  //       },
  //     ),
  //     request: const AdRequest(),
  //   );
  //   nativeAd!.load();
  // }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool frombgRemove = arguments?['frombgRemove'] ?? false;
    final bool fromObjectRemove = arguments?['fromObjectRemove'] ?? false;
    final bool fromAIReplace = arguments?['fromAIReplace'] ?? false;
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
        title: Consumer<LocalizationProvider>(builder:
            (BuildContext context, LocalizationProvider value, Widget? child) {
          return Text(
            localeText(
              context,
              'upload_your_photo',
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
          width: 64,
          height: 24,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      frombgRemove
                          ? localeText(context,
                              'upload_your_photo_well_remove_the_background_effortlessly_for_you')
                          : fromObjectRemove
                              ? localeText(context,
                                  'upload_your_photo_well_remove_objects_from_image_effortlessly_for_you')
                              : fromAIReplace
                                  ? localeText(context,
                                      'upload_your_photo_well_replace_objects_from_image_effortlessly_for_you')
                                  : localeText(context,
                                      'upload_your_photo_well_enhance_it_effortlessly_for_you'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.42,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    UploadButton(
                      buttonText: localeText(
                        context,
                        'upload',
                      ),
                      onPressed: () async {
                        final imageProvider = Provider.of<ImagePickerProvider>(
                            context,
                            listen: false);
                        if (fromAIReplace) {
                          final imageProvider =
                              Provider.of<ImagePickerProvider>(context,
                                  listen: false);
                          imageProvider.originalImage = null;
                          await imageProvider.loadImage();
                          // bool pikcedImage = await imageProvider.loadImage();

                          if (imageProvider.originalImage != null) {
                            Navigator.pushNamed(context, RouteHelper.aiReplace,
                                arguments: {
                                  'bgRemovedImage': imageProvider.originalImage
                                });
                          }
                        } else if (fromObjectRemove) {
                          final imageProvider =
                              Provider.of<ImagePickerProvider>(context,
                                  listen: false);
                          imageProvider.originalImage = null;
                          await imageProvider.loadImage();
                          // bool pikcedImage = await imageProvider.loadImage();
                          if (imageProvider.originalImage != null) {
                            Navigator.pushNamed(
                                context, RouteHelper.objectRemove, arguments: {
                              'bgRemovedImage': imageProvider.originalImage
                            });
                          }
                        }
                        // Navigator.pushNamed(
                        else if (frombgRemove) {
                          bool pickedFile =
                              await imageProvider.getImageFromGallery();

                          if (pickedFile) {
                            String? bgRemoved = await removebg();
                            if (bgRemoved != null) {
                              Navigator.pushNamed(
                                context,
                                RouteHelper.bgRemover,
                                arguments: {'bgRemovedImage': bgRemoved},
                              );
                            }
                          }
                        } else if (!fromAIReplace &&
                            !fromObjectRemove &&
                            !frombgRemove) {
                          // Navigator.pushNamed(
                          //     context, RouteHelper.advancedSettings);
                          bool imaagpeicke =
                              await imageProvider.getImageFromGallery();
                          if (imaagpeicke) {
                            showDialog(
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
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
                                      // Dialog content
                                      AdvancedSettings(
                                          pickedImage: imageProvider.image),
                                    ],
                                  ),
                                );
                              },
                              barrierDismissible: true,
                            );
                          }
                        }
                      },
                      imagePath: 'assets/icons/file_upload.webp',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    UploadButton(
                      buttonText: localeText(
                        context,
                        'camera',
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        if (fromAIReplace) {
                          final imageProvider =
                              Provider.of<ImagePickerProvider>(context,
                                  listen: false);
                          imageProvider.originalImage = null;
                          await imageProvider.loadImagefromcamera();
                          // bool pikcedImage = await imageProvider.loadImage();

                          if (imageProvider.originalImage != null) {
                            Navigator.pushNamed(context, RouteHelper.aiReplace,
                                arguments: {
                                  'bgRemovedImage': imageProvider.originalImage
                                });
                          }
                        }
                        final imageProvider = Provider.of<ImagePickerProvider>(
                            context,
                            listen: false);
                        if (fromObjectRemove) {
                          final imageProvider =
                              Provider.of<ImagePickerProvider>(context,
                                  listen: false);
                          imageProvider.originalImage = null;
                          await imageProvider.loadImagefromcamera();
                          // bool pikcedImage = await imageProvider.loadImage();
                          if (imageProvider.originalImage != null) {
                            Navigator.pushNamed(
                                context, RouteHelper.objectRemove, arguments: {
                              'bgRemovedImage': imageProvider.originalImage
                            });
                          }
                        } else if (frombgRemove) {
                          bool pickedFile =
                              await imageProvider.getImageFromCamera();

                          if (pickedFile) {
                            String? bgRemoved = await removebg();
                            if (bgRemoved != null) {
                              Navigator.pushNamed(
                                context,
                                RouteHelper.bgRemover,
                                arguments: {'bgRemovedImage': bgRemoved},
                              ).then((value) => (setState(() {
                                    _isLoading = false;
                                  })));
                            }
                          }
                        } else if (!fromAIReplace &&
                            !fromObjectRemove &&
                            !frombgRemove) {
                          bool imaagpeicke =
                              await imageProvider.getImageFromCamera();
                          setState(() {
                            _isLoading = false;
                          });
                          if (imaagpeicke) {
                            final imageProvider =
                                Provider.of<ImagePickerProvider>(
                              context,
                              listen: false,
                            );
                            // Navigator.pushNamed(
                            //     context, RouteHelper.advancedSettings);
                            // ignore: use_build_context_synchronously
                            showDialog(
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.9),
                                  child: Stack(
                                    children: [
                                      // Background content
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0,
                                            sigmaY:
                                                10.0), // Adjust the sigma values for more/less blur
                                        child: Container(
                                          color: Colors
                                              .transparent, // Adjust the opacity for the desired blur effect
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                        ),
                                      ),
                                      // Dialog content
                                      AdvancedSettings(
                                          pickedImage: imageProvider.image),
                                    ],
                                  ),
                                );
                              },
                              barrierDismissible: true,
                            );
                          }
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      imagePath: 'assets/icons/camera.webp',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(child: Container()),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //  NativeAdWidgetMedia()
                          ],
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius here
                          color: Colors.white, // Optional: Set background color
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Match the radius with the Container
                          child: const NativeAdWidgetMedia(),
                        ))
                  ]),
            ),
            if (_isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Center(
                    child: Container(
                  color: Colors.black38,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: LoadingAnimation(
                    loadingText: localeText(context, 'please_wait'),
                    generatingText: loadingText,
                    customLoadingWidget: const SpinKitSpinningLines(
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )),
              )
            //  AdvancedSettings(),
          ],
        ),
      ),
    );
  }

  void updateLoadingState(String text, bool loading) {
    if (mounted) {
      setState(() {
        loadingText = text;
        _isLoading = loading;
      });
    }
  }

  Future<ui.Image> convertFileToImage(File file) async {
    final ByteData data = await file
        .readAsBytes()
        .then((value) => ByteData.sublistView(Uint8List.fromList(value)));
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  final CancelToken _cancelToken = CancelToken();
  Future<String?> removebg() async {
    final imageProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    updateLoadingState("Preparing..", true);
    await Future.delayed(const Duration(milliseconds: 500));
    // Create Dio instance
    final dio = Dio();

// Create ApiRepository instance
    final apiRepository = ApiRepository(ApiClient(dio));
    updateLoadingState("Removing Background for you..", true);
    try {
      String? removedBackgroundImage = await apiRepository
          .removeBgApi(imageProvider.image!.path, cancelToken: _cancelToken);
      imageProvider.setBgRemovedImage(removedBackgroundImage);
      updateLoadingState("Finalizing..", true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      return removedBackgroundImage;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print("Request canceled!");
      }
      rethrow; // Or handle the error as you see fit
    } on NetworkUnavailableException catch (e) {
      // Handle specific network unavailable exceptions
      print('$e');
      _showErrorPopup(context, 'Error',
          'Network is unreachable. Please check your internet connection.');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on HttpClientException catch (e) {
      // Handle specific HTTP client exceptions
      print('$e');
      _showErrorPopup(
          context, 'Error', 'An error occurred in the HTTP client.');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on SocketExceptionWrapper catch (e) {
      // Handle specific socket exceptions
      print('$e');
      if (e.isNetworkUnreachable) {
        _showErrorPopup(context, 'Error',
            'Network is unreachable. Please check your internet connection.');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        _showErrorPopup(context, 'Error', 'A network error occurred.');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on BadRequestException catch (e) {
      // Handle specific bad request exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'Bad request. Please check your input.');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on UnauthorizedException catch (e) {
      // Handle specific unauthorized exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'Unauthorized. Please check your credentials.');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on NotFoundException catch (e) {
      // Handle specific not found exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(context, 'Error', 'Resource not found.');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on ApiException catch (e) {
      // Handle other generic API exceptions
      print('$e');
      if (mounted) {
        _showErrorPopup(
            context, 'Error', 'An API error occurred: ${e.message}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      if (mounted) {
        _showErrorPopup(context, 'Error', 'An unexpected error occurred.+$e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
