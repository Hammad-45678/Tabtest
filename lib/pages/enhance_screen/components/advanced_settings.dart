import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/pages/enhance_screen/pages/editphoto_screen.dart';
import 'package:picstar/pages/enhance_screen/widgets/ai_enhance_button.dart';
import 'package:picstar/pages/enhance_screen/widgets/ai_enhancepre_button.dart';
import 'package:picstar/translation_manager/language_constants.dart';

import '../../../global/widgets/ad_manager.dart';
import '../../../global/widgets/adloading.dart';

class AdvancedSettings extends StatefulWidget {
  const AdvancedSettings({Key? key, this.pickedImage}) : super(key: key);
  final XFile? pickedImage;

  @override
  State<AdvancedSettings> createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  final bool _isLoading = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double containerWidth =
                      constraints.maxWidth < 327 ? constraints.maxWidth : 327;
                  double containerHeight =
                      constraints.maxHeight < 600 ? constraints.maxHeight : 620;

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 165, 164,
                            164), // Set the desired border color here
                        width: 1.0, // Set the desired border width here
                      ),
                    ),
                    width: containerWidth,
                    height: containerHeight,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17.0, vertical: 7),
                                child: Image(
                                  image:
                                      AssetImage('assets/icons/btn_back.webp'),
                                  height: 27,
                                  width: 27,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: Text(
                                localeText(
                                  context,
                                  'advance_settings',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.48,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17.0, vertical: 7),
                              child: SizedBox(
                                height: 27,
                                width: 27,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration:
                              const BoxDecoration(color: Color(0xFF646464)),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: containerWidth - 34, // Adjusted width
                          height: containerHeight * 0.72, // Adjusted height
                          decoration: ShapeDecoration(
                            image: widget.pickedImage != null
                                ? DecorationImage(
                                    image: FileImage(
                                        File(widget.pickedImage!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/293x450"),
                                    fit: BoxFit.cover,
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                                onTap: () {
                                  if (widget.pickedImage != null) {
                                    _adHelper!.createRewardedAd();
                                    adManager.showRewardedAd(context, () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPhoto(
                                            pickedImage: widget.pickedImage,
                                            isLoading: true,
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    // Handle the case where pickedImage is null
                                    print('No image selected');
                                  }
                                },
                                child: CustomEnhanceButton(
                                  imagePath: 'assets/icons/video_icon.webp',
                                  buttonText: localeText(context, 'ai_enhance'),
                                  descriptionText: localeText(
                                      context, 'this_action_may_contain_ads'),

                                  // descriptionTextFontSize: 7,
                                  width: double.infinity,
                                ))),
                        const SizedBox(
                          height: 5,
                        ),
                        ai_enhance_pre_button(
                          buttonText: localeText(
                            context,
                            'premium',
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Center(
              child: LoadingAnimation(
            loadingText: 'Please wait...',
            generatingText: 'Preparing your',
            customLoadingWidget: SpinKitSpinningLines(
              color: Colors.white,
              size: 50,
            ),
            resultText: 'image',
          )),
        if (_isLoadingAd) const Center(child: AdLoading())
      ]),
    );
  }
}
