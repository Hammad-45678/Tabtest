import 'package:flutter/material.dart';
import 'package:picstar/global/widgets/button.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/ad_widget_banner.dart';

class AiReplaceBottomSheet {
  void showSettingModalBottomSheet(BuildContext context, Function onClose) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return AiReplaceBottomSheetContent(onClose: onClose);
      },
    );
  }
}

class AiReplaceBottomSheetContent extends StatefulWidget {
  final Function onClose;

  const AiReplaceBottomSheetContent({super.key, required this.onClose});
  @override
  _AiReplaceBottomSheetContentState createState() =>
      _AiReplaceBottomSheetContentState();
}

TextEditingController _textEditingController = TextEditingController();
int selectedIndex = -1;
double _currentSliderValue = 20;
List<ItemModel> items = List.generate(
  12,
  (index) => ItemModel(
    imagePath: 'assets/images/ai_generator_images/ai_img0.png',
    title: 'Cyberpunk $index',
  ),
);

class _AiReplaceBottomSheetContentState
    extends State<AiReplaceBottomSheetContent> {
  // Add the necessary state variables and methods here

  @override
  Widget build(
    BuildContext context,
  ) {
    ImagePickerProvider imageeditorprovider =
        Provider.of<ImagePickerProvider>(context);
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapped outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(15),
          ),
          child: Container(
              color: const Color(0xFF222222),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(15)),
                child: Container(
                  color: const Color(0xFF222222),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Image(
                          image:
                              AssetImage('assets/icons/bottomSheetHandle.webp'),
                          width: 50,
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localeText(
                                context,
                                'ai_replacement',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 0,
                                letterSpacing: 0.48,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-1.00, 0.00),
                            end: Alignment(1, 0),
                            colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'write_your_prompt',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                localeText(context,
                                    'add_a_simple_specific_description_for_best_results_keep_it_as_short_as_possible'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 120,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 0),
                                child: Center(
                                  child: TextField(
                                    controller:
                                        imageeditorprovider.promptController,
                                    onChanged: (text) {
                                      imageeditorprovider.setPromptText('');
                                      imageeditorprovider.setPromptText(text);
                                      // You can handle text input changes if needed
                                    },
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.30,
                                    ),
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText:
                                          localeText(context, 'type_here'),
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         localeText(
                      //           context,
                      //           'or_pick_a_replacement',
                      //         ),
                      //         style: const TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 300,
                      //   child: GridView.builder(
                      //       physics: const NeverScrollableScrollPhysics(),
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 4,
                      //         crossAxisSpacing: 8.0,
                      //         mainAxisSpacing: 0.0,
                      //       ),
                      //       itemCount: items.length,
                      //       itemBuilder: (context, index) {
                      //         ItemModel item = items[index];
                      //         bool isSelected = selectedIndex == index;

                      //         return GestureDetector(
                      //             onTap: () {
                      //               setState(() {
                      //                 selectedIndex = isSelected ? -1 : index;
                      //               });
                      //             },
                      //             child: Column(
                      //                 mainAxisAlignment: MainAxisAlignment.center,
                      //                 children: [
                      //                   Container(
                      //                     width: 59.13,
                      //                     height: 59.13,
                      //                     decoration: ShapeDecoration(
                      //                       shape: RoundedRectangleBorder(
                      //                         side: BorderSide(
                      //                           width: 1,
                      //                           color: isSelected
                      //                               ? const Color(0xFF8181FF)
                      //                               : Colors.white,
                      //                         ),
                      //                         borderRadius:
                      //                             BorderRadius.circular(10),
                      //                       ),
                      //                     ),
                      //                     child: Stack(
                      //                       children: [
                      //                         Column(
                      //                           children: [
                      //                             Image(
                      //                               image: AssetImage(
                      //                                   item.imagePath),
                      //                               fit: BoxFit.contain,
                      //                             )
                      //                           ],
                      //                         ),
                      //                         if (isSelected)
                      //                           const Positioned.fill(
                      //                             child: Center(
                      //                               child: Image(
                      //                                 image: AssetImage(
                      //                                     'assets/icons/checkmarkRounded.webp'),
                      //                                 width: 15,
                      //                                 height: 15,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   const SizedBox(
                      //                     height: 2,
                      //                   ),
                      //                   Text(
                      //                     item.title,
                      //                     style: TextStyle(
                      //                       color: isSelected
                      //                           ? const Color(0xFF8181FF)
                      //                           : Colors.white,
                      //                       fontSize: 10,
                      //                       fontWeight: FontWeight.w400,
                      //                       letterSpacing: 0.30,
                      //                     ),
                      //                   ),
                      //                 ]));
                      //       }),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GlobalButton(
                            buttonText: localeText(
                              context,
                              'generate',
                            ),
                            onPressed: () {
                              widget.onClose();
                            }),
                      ),
                      Expanded(child: Container()),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius here
                          color: Colors.white, // Optional: Set background color
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Match the radius with the Container
                          child: const NativeAdWidgetBanner(),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

class ItemModel {
  final String imagePath;
  final String title;

  ItemModel({required this.imagePath, required this.title});
}
