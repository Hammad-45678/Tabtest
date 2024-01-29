import 'dart:io';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/pages/drawer/drawer.dart';
import 'package:picstar/pages/home_screen/animations/comparisonAnimation.dart';
import 'package:picstar/pages/home_screen/animations/slideshow.dart';
import 'package:picstar/pages/home_screen/animations/text_animation.dart';
import 'package:picstar/pages/home_screen/widgets/bg_remove.dart';
import 'package:picstar/pages/home_screen/widgets/custom_button.dart';
import 'package:picstar/pages/home_screen/widgets/object_removed.dart';
import 'package:picstar/shared/routes/routes.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/ad_manager.dart';
import '../../../global/widgets/ad_widget.dart';
import '../../../shared/constants/ad_constants.dart';
import '../../../translation_manager/language_constants.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

bool _isLoadingAd = false;
final adManager = AdManager();
AdManager? _adHelper;
NativeAd? nativeAd;
bool isNativeAdLoaded = false;
bool isIOS = Platform.isIOS;
bool isIpad(SizingInformation sizingInformation) {
  return sizingInformation.deviceScreenType == DeviceScreenType.tablet;
}

class _home_pageState extends State<home_page> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only load the ad if it has not been loaded or disposed
    if (nativeAd == null) {
      loadNativeAd();
    }
  }

  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: Platform.isIOS
          ? AdConstants.iosAdUnitId // Use iOS ad unit ID
          : AdConstants.androidAdUnitId, // Use Android ad unit ID
      factoryId: "listTile",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          nativeAd!.dispose();
        },
      ),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 20 : 12;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: CustomAppBar(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        height: 50,
        firstleadingImage: Image.asset(
          'assets/icons/menu.webp',
          height: 27,
        ),
        secondleadingImage: Image.asset(
          'assets/icons/menu.webp',
          height: 27,
        ),
        title: const Text(
          'Picstar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            height: 0,
            letterSpacing: 3.60,
          ),
        ),
        trailingImage: Image.asset(
          'assets/icons/pro.webp',
          height: 24,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: Container(
            //     width: double.infinity,
            //     height: 1,
            //     decoration: const BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment(-1.00, 0.00),
            //         end: Alignment(1, 0),
            //         colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
            //       ),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () async {
                adManager.createInterstitialAd();
                adManager.showInterstitialAd();

                // Navigate immediately if the ad isn't loaded
                Navigator.pushNamed(context, RouteHelper.enhanceImage);
              },
              // Rest of your GestureDetector code

              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Consumer<LocalizationProvider>(
                      builder: (context, localizationProvider, child) {
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: getContainerHeight(context),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF8181FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveBuilder(
                                builder: (context, sizingInformation) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 10, right: 10),
                                    child: Text(
                                      localeText(
                                        context,
                                        'ai_enhancer',
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getFontSize(sizingInformation),
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, left: 10, right: 10),
                                  child: Text(
                                    localeText(
                                      context,
                                      'enhance_photos_for_stunning_visual_appeal',
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 27, right: 10),
                                  child: CustomElevatedButton(
                                    buttonText: localeText(
                                      context,
                                      'edit_photo',
                                    ),
                                    onPressed: () {
                                      adManager.createInterstitialAd();
                                      adManager.showInterstitialAd();
                                      Navigator.pushNamed(
                                          context, RouteHelper.enhanceImage);
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: localizationProvider.checkIsArOrUr() ? 0 : 200,
                          right: localizationProvider.checkIsArOrUr() ? 200 : 0,
                          child: Transform(
                            transform: localizationProvider.checkIsArOrUr()
                                ? Matrix4.rotationY(3.2)
                                : Matrix4.identity(),
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 200,
                              height: getContainerHeight(context),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) // Adjust the value as needed
                                        ),
                                    child: SizedBox(
                                      height: getContainerHeight(context),
                                      child: comparisonAnimation(
                                        image1: AssetImage(
                                            'assets/images/image2.webp'),
                                        image2: AssetImage(
                                            'assets/images/image1.webp'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
            ),

            GestureDetector(
              onTap: () {
                adManager.createInterstitialAd();
                adManager.showInterstitialAd();
                Navigator.pushNamed(context, RouteHelper.aiGenerator);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Consumer<LocalizationProvider>(
                      builder: (context, localizationProvider, child) {
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: getContainerHeight(context),
                          decoration: ShapeDecoration(
                            color: Color(0xFFC74EC8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveBuilder(
                                builder: (context, sizingInformation) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 10, right: 10),
                                    child: Text(
                                      localeText(
                                        context,
                                        'ai_generator',
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getFontSize(sizingInformation),
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, left: 10, right: 10),
                                child: textAnimation(),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 27, right: 10),
                                  child: CustomElevatedButton(
                                    buttonText: localeText(
                                      context,
                                      'edit_photo',
                                    ),
                                    onPressed: () {
                                      adManager.createInterstitialAd();
                                      adManager.showInterstitialAd();
                                      Navigator.pushNamed(
                                          context, RouteHelper.enhanceImage);
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: localizationProvider.checkIsArOrUr() ? 0 : 200,
                          right: localizationProvider.checkIsArOrUr() ? 200 : 0,
                          child: Transform(
                            transform: localizationProvider.checkIsArOrUr()
                                ? Matrix4.rotationY(3.2)
                                : Matrix4.identity(),
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 200,
                              height: getContainerHeight(context),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) // Adjust the value as needed
                                        ),
                                    child: SizedBox(
                                      height: getContainerHeight(context),
                                      child: ImageSlideshow(
                                        imageAssets: const [
                                          'assets/images/anime_girl.png',
                                          'assets/images/santa.png',
                                          'assets/images/cottage.png',
                                          'assets/images/boy.png',
                                          // Add more image URLs to the list
                                        ],
                                        isUrdu: localizationProvider
                                            .checkIsArOrUr(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius here
                  color: Colors.white, // Optional: Set background color
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Match the radius with the Container
                  child: const NativeAdWidget(),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: index == 0
                            ? GestureDetector(
                                onTap: () {
                                  adManager.createInterstitialAd();
                                  adManager.showInterstitialAd();
                                  Navigator.pushNamed(
                                      context, RouteHelper.enhanceImage,
                                      arguments: {
                                        'fromObjectRemove': index == 0
                                      });
                                },
                                child: const ObjectRemoveWidget())
                            : index == 1
                                ? GestureDetector(
                                    onTap: () {
                                      adManager.createInterstitialAd();
                                      adManager.showInterstitialAd();
                                      Navigator.pushNamed(
                                          context, RouteHelper.enhanceImage,
                                          arguments: {
                                            'fromAIReplace': index == 1
                                          });
                                    },
                                    child: const AiReplaceWidget())
                                : // Your other code for index != 1

                                index == 2
                                    ? GestureDetector(
                                        onTap: () {
                                          adManager.createInterstitialAd();
                                          adManager.showInterstitialAd();
                                          Navigator.pushNamed(
                                              context, RouteHelper.enhanceImage,
                                              arguments: {
                                                'frombgRemove': index == 2
                                              });
                                        },
                                        child: const BgRemoveWidget(),
                                      )
                                    : Container(
                                        //   width: 130,
                                        //   height: 80,
                                        //   decoration: const ShapeDecoration(
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(10)),
                                        //       side: BorderSide(
                                        //         width: 1, // Border width
                                        //         color: Colors
                                        //             .transparent, // Transparent color for the border
                                        //         style: BorderStyle.solid,
                                        //       ),
                                        //     ),
                                        //     gradient: LinearGradient(
                                        //       begin: Alignment(-1.00, 0.00),
                                        //       end: Alignment(1, 0),
                                        //       colors: [
                                        //         Color(0xFF8181FF),
                                        //         Color(0xFFC74EC8)
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   child: Stack(
                                        //     fit: StackFit.expand,
                                        //     children: [
                                        //       // Image placed inside the container
                                        //       ClipRRect(
                                        //         borderRadius:
                                        //             const BorderRadius.only(
                                        //                 bottomRight:
                                        //                     Radius.circular(10)),
                                        //         child: Image.asset(
                                        //           customSlide[index].image,
                                        //           fit: BoxFit.contain,
                                        //         ),
                                        //       ),
                                        //       // Text overlaid at the center bottom of the image
                                        //       Positioned(
                                        //         left: 0,
                                        //         right: 0,
                                        //         bottom: 0,
                                        //         child: Container(
                                        //           padding:
                                        //               const EdgeInsets.symmetric(
                                        //                   vertical: 8),
                                        //           child: Center(
                                        //             child: Text(
                                        //               customSlide[index].name,
                                        //               style: const TextStyle(
                                        //                 color: Colors.white,
                                        //                 fontSize: 10,
                                        //                 fontFamily: 'Urbanist',
                                        //                 fontWeight:
                                        //                     FontWeight.w800,
                                        //                 height: 0.22,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // )
                                        ));
                  }),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         localeText(
            //           context,
            //           'recent',
            //         ),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 12,
            //           fontWeight: FontWeight.w500,
            //           height: 0,
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       Opacity(
            //         opacity: 0.50,
            //         child: Text(
            //           localeText(
            //             context,
            //             'draft',
            //           ),
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontSize: 12,
            //             fontWeight: FontWeight.w500,
            //             height: 0,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 8,
            ),
            // SizedBox(
            //   height: 200,
            //   child: ListView(
            //     children: List.generate(
            //       5,
            //       (index) => Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 15.0, vertical: 5),
            //         child: Container(
            //           height: 50,
            //           decoration: ShapeDecoration(
            //             color: const Color(0xFFE6E6E6),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //           ),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(
            //                   horizontal: 5.0,
            //                   vertical: 5,
            //                 ),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(5),
            //                   child: Container(
            //                     width: 50.89,
            //                     height: 33.15,
            //                     decoration: const BoxDecoration(
            //                       image: DecorationImage(
            //                         image: AssetImage(
            //                             'assets/images/user.webp'),
            //                         fit: BoxFit.fill,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(
            //                 width: 15,
            //               ),
            //               const Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     '102558741698_845563287',
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 10,
            //                       fontWeight: FontWeight.w600,
            //                       height: 0,
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 5,
            //                   ),
            //                   Text(
            //                     '7.4 MB',
            //                     style: TextStyle(
            //                       color: Color(0xFF848484),
            //                       fontSize: 10,
            //                       fontWeight: FontWeight.w500,
            //                       height: 0,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               Expanded(child: Container()),
            //               const Padding(
            //                 padding: EdgeInsets.symmetric(horizontal: 18.0),
            //                 child: Image(
            //                     image:
            //                         AssetImage('assets/icons/3dots.webp')),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            //  CustomNativeAd(),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}

class AiReplaceWidget extends StatelessWidget {
  const AiReplaceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 18 : 12;
    return Container(
      height: getContainerHeight2(context),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            width: 1, // Border width
            color: Colors.transparent, // Transparent color for the border
            style: BorderStyle.solid,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment(-1.00, 0.00),
          end: Alignment(1, 0),
          colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/ai_replace.gif',
                height: getContainerHeight2(context),
                fit: BoxFit.cover,
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height > 600 ? 20 : 15,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: Text(
                      localeText(
                        context,
                        'ai_replace',
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        height: 0.22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomVerticalSlide {
  final String image;
  final String filename;
  final String filesize;
  final String icon;

  CustomVerticalSlide(this.filesize, this.icon,
      {required this.image, required this.filename});
}

double getContainerHeight(BuildContext context) {
  // Create an instance of your localizationProvider class or use a global object
  var localizationProvider = LocalizationProvider();

  double baseHeight = localizationProvider.checkIsArOrUr() ? 160 : 140;
  double screenWidth = MediaQuery.of(context).size.shortestSide;

  // Adjust the base height for iPad or larger screens
  if (screenWidth > 600) {
    return baseHeight * 1.6; // Adjust the multiplier as needed
  } else {
    return baseHeight;
  }
}

double getFontSize(SizingInformation sizingInformation) {
  if (isIpad(sizingInformation)) {
    return 34.0; // Set a larger font size for iPad
  } else {
    return 18.0; // Default font size for other devices
  }
}

double getContainerHeight2(BuildContext context) {
  // Create an instance of your localizationProvider class or use a global object
  var localizationProvider = LocalizationProvider();

  double baseHeight = localizationProvider.checkIsArOrUr() ? 80 : 80;
  double screenWidth = MediaQuery.of(context).size.shortestSide;

  // Adjust the base height for iPad or larger screens
  if (screenWidth > 600) {
    return baseHeight * 1.6; // Adjust the multiplier as needed
  } else {
    return baseHeight;
  }
}
