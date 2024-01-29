import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:picstar/utils/image_save.dart';
import 'package:provider/provider.dart';

import '../../global/widgets/loading_animation.dart';
import '../../global/widgets/saving_dialog.dart';
import '../../translation_manager/language_constants.dart';

class ShowEnhanced extends StatelessWidget {
  const ShowEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    final String? apiResponseImageHd =
        ModalRoute.of(context)?.settings.arguments as String?;
    return WillPopScope(
      onWillPop: () async {
        // Handle the back press event here
        Navigator.pop(context);
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
                  letterSpacing: value.checkIsArOrUr() ? 0 : 3.60,
                ));
          }),
          trailingImage: GestureDetector(
            onTap: () async {
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
                          loadingText: localeText(context, 'saved_to_gallery'),
                          generatingText:
                              localeText(context, 'your_file_has_been'),
                          customLoadingWidget: const Image(
                            image: AssetImage(
                              'assets/icons/check.webp',
                            ),
                            width: 32,
                            height: 32,
                          ),
                          resultText: localeText(
                              context, 'successfully_saved_into_your_gallery'),
                        )
                      ]));
                },
              );
              SaveImageToGallery.downloadAndSaveImage(apiResponseImageHd!);

              // Now call the instance method on the created object
            },
            child: Image.asset(
              'assets/icons/download_purple.webp',
              width: 67,
              height: 24,
            ),
          ),
        ),
        body: Stack(children: [
          Column(children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height / 2,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: apiResponseImageHd != null
                    ? CachedNetworkImage(
                        imageUrl: apiResponseImageHd,
                        placeholder: (context, url) => const Center(
                          child: SpinKitSpinningLines(color: Color(0xFF8181FF)),
                        ),
                      )
                    : const Center(
                        child: Text('Error loading enhanced image'),
                      ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
