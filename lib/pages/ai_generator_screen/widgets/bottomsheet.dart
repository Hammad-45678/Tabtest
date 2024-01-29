import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:picstar/global/widgets/button.dart';
import 'package:picstar/pages/ai_generator_screen/model/samplingmeethod.dart';
import 'package:picstar/pages/enhance_screen/provider/image_provider.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:provider/provider.dart';

import '../apiclient/samplingMethod/samplingMethods.dart';

class SettingModalBottomSheet {
  void showSettingModalBottomSheet(
      BuildContext context,
      Function(String?, TextEditingController, TextEditingController, double,
              String?)
          callback) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return SettingModalContent(callback: callback);
      },
    );
  }
}

class SettingModalContent extends StatefulWidget {
  final Function(String?, TextEditingController, TextEditingController, double,
      String?) callback;

  const SettingModalContent({super.key, required this.callback});
  @override
  _SettingModalContentState createState() => _SettingModalContentState();
}

TextEditingController _seeed = TextEditingController(text: "-1");
TextEditingController _negativePrompt = TextEditingController(
    text:
        "ugly, deformed, noisy, blurry, distorted, out of focus, bad anatomy, extra limbs, poorly drawn face, poorly drawn hands, missing fingers");
int selectedIndex = 0;

// String? _samplingMethod;

final List<String> dropdownitems = [
  'Euler a',
];
int selectedIndex2 = 0;
String? _selectedSize;
SamplingMethodModel? _samplingMethod;
final List<Map<String, dynamic>> items = [
  {'image': 'assets/icons/crop1.webp', 'text': 'square', 'size': 'square'},
  {'image': 'assets/icons/crop2.webp', 'text': '1:1', 'size': 'reel'},
  {'image': 'assets/icons/crop3.webp', 'text': '16:9', 'size': 'cover'},
  {'image': 'assets/icons/crop4.webp', 'text': '4:3', 'size': 'post'},
  {'image': 'assets/icons/crop5.webp', 'text': '3:4', 'size': 'portrait'},
];

class _SettingModalContentState extends State<SettingModalContent> {
  // Add the necessary state variables and methods here
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  late List<SamplingMethodModel> samplingMethods = [];

  Future<void> fetchData() async {
    try {
      final apiService = SamplingMethods();
      final fetchedItems = await apiService.fetchItems(context);

      setState(() {
        samplingMethods = fetchedItems;
        _samplingMethod = fetchedItems.isNotEmpty ? fetchedItems[0] : null;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(shrinkWrap: true, children: [
        ClipRRect(
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
                            GestureDetector(
                              onTap: () {
                                clearTextFields();
                              },
                              child: SizedBox(
                                width: 80,
                                child: Text(
                                  textAlign: TextAlign.right,
                                  localeText(
                                    context,
                                    'reset',
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF8181FF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: 0.48,
                                  ),
                                ),
                              ),
                            )
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
                                'select_size',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        // Adjust the height as needed
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    _selectedSize = (items[index]['size']);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/icons/crop_icons/crop${index + 1}.png'),
                                        width: 30,
                                        height: 30,
                                        color: selectedIndex == index
                                            ? const Color(
                                                0xFF8181FF) // Change the color as needed
                                            : null,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        items[index]['text'],
                                        style: TextStyle(
                                          color: selectedIndex == index
                                              ? const Color(
                                                  0xFF8181FF) // Change the color as needed
                                              : Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'negative_prompt',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Image(
                              image:
                                  AssetImage('assets/icons/information.webp'),
                              width: 14,
                              height: 14,
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
                              height: 70,
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
                                    controller: _negativePrompt,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.30,
                                    ),
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      hintText:
                                          localeText(context, 'type_here'),
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(5),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'sampling_method',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Image(
                              image:
                                  AssetImage('assets/icons/information.webp'),
                              width: 14,
                              height: 14,
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
                              height: 40,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2<
                                            SamplingMethodModel>(
                                          isExpanded: true,
                                          hint: Text(
                                            localeText(
                                              context,
                                              'select_method',
                                            ),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                          items: samplingMethods
                                              .map((SamplingMethodModel item) =>
                                                  DropdownMenuItem<
                                                      SamplingMethodModel>(
                                                    value: item,
                                                    child: Text(
                                                      item.title,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: _samplingMethod,
                                          onChanged:
                                              (SamplingMethodModel? value) {
                                            setState(() {
                                              _samplingMethod = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              maxHeight: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: const Color.fromARGB(
                                                    255, 52, 52, 52),
                                              )),
                                        ),
                                      ),
                                    ],
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'sampling_steps',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Image(
                              image:
                                  AssetImage('assets/icons/information.webp'),
                              width: 14,
                              height: 14,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.5,
                            child: SliderTheme(
                              data: const SliderThemeData(
                                trackHeight:
                                    1.0, // Set the height for both active and inactive portions
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0),
                              ),
                              child: Consumer<ImagePickerProvider>(
                                  builder: (context, sliderprovider, child) {
                                return Slider(
                                  value: sliderprovider.samplingStepsSlider,
                                  max: 100,
                                  divisions: 20,
                                  activeColor: const Color(0xFFD9D9D9),
                                  inactiveColor: const Color(0xFFD9D9D9),
                                  thumbColor: Colors.white,
                                  onChanged: (double value) {
                                    sliderprovider
                                        .updateSamplingSliderValue(value);
                                  },
                                );
                              }),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                                width: 60,
                                height: 30,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Consumer<ImagePickerProvider>(builder:
                                      (context, sliderprovider, child) {
                                    return Text(
                                      '${sliderprovider.samplingStepsSlider.round()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }),
                                )),
                          ),
                        ],
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Sampling Steps',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w300,
                      //           height: 0,
                      //         ),
                      //       ),
                      //       SizedBox(width: 10),
                      //       Image(
                      //         image: AssetImage('assets/icons/information.webp'),
                      //         width: 14,
                      //         height: 14,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Slider(
                      //       value: _currentSliderValue,
                      //       max: 100,
                      //       divisions: 5,
                      //       label: _currentSliderValue.round().toString(),
                      //       onChanged: (double value) {
                      //         setState(() {
                      //           _currentSliderValue = value;
                      //         });
                      //       },
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //       child: Container(
                      //           width: 60,
                      //           height: 30,
                      //           decoration: ShapeDecoration(
                      //             shape: RoundedRectangleBorder(
                      //               side: const BorderSide(
                      //                   width: 1, color: Colors.white),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //           ),
                      //           child: const Center(
                      //             child: Text(
                      //               '20',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 14,
                      //                 fontFamily: 'Urbanist',
                      //                 fontWeight: FontWeight.w500,
                      //                 height: 0,
                      //               ),
                      //             ),
                      //           )),
                      //     ),
                      //   ],
                      // )
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'seed',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                height: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Image(
                              image:
                                  AssetImage('assets/icons/information.webp'),
                              width: 14,
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 40,
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
                                        keyboardType: TextInputType.phone,
                                        controller: _seeed,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.30,
                                        ),
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText: 'Type here...',
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15),
                        child: Consumer<ImagePickerProvider>(builder:
                            (BuildContext context, ImagePickerProvider value,
                                Widget? child) {
                          return GlobalButton(
                              buttonText: "Apply",
                              onPressed: () {
                                widget.callback(
                                    _samplingMethod != null
                                        ? _samplingMethod!.title
                                        : 'Euler a',
                                    _seeed,
                                    _negativePrompt,
                                    value.samplingStepsSlider,
                                    _selectedSize);
                                print('--->>>>>>>>>>>>>');
                                //    print(_samplingMethod!.title);
                                print(_seeed);
                                print(_negativePrompt);
                                print(value.samplingStepsSlider);
                                print(_selectedSize);
                                Navigator.pop(context);
                              });
                        }),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ]),
    );
  }

  void clearTextFields() {
    _seeed.clear();
    _negativePrompt.clear();
  }
}
