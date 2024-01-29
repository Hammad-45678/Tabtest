import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picstar/global/widgets/button.dart';
import 'package:picstar/global/widgets/custom_app_bar_wdiget.dart';
import 'package:picstar/global/widgets/loading_animation.dart';
import 'package:picstar/pages/ai_generator_screen/apiclient/styles_list/styles.dart';

import 'package:picstar/pages/ai_generator_screen/widgets/bottomsheet.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/custom_button.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/generating_artwork.dart';
import 'package:picstar/shared/routes/routes.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../global/widgets/ad_manager.dart';
import '../../global/widgets/ad_widget_media.dart';
import '../../global/widgets/adloading.dart';
import '../enhance_screen/provider/image_provider.dart';
import 'apiclient/ai_generator/apiclient.dart';
import 'apiclient/img2prompt/img2prompt.dart';

import 'model/model.dart';

class AiGenerator extends StatefulWidget {
  AiGenerator({super.key});

  @override
  State<AiGenerator> createState() => _AiGeneratorState();
}

class _AiGeneratorState extends State<AiGenerator> {
  int paragraphCount = 0;
  bool isLoading = false;
  bool isGridLoading = false;
  int? _selectedStylesid;
  late TextEditingController _textController;
  String? _negative;
  String? _seed;
  String? _caption;
  String? _samplingMethod;
  double? _slidervalue;
  String? _selectedSize;
  String? loadingText = "initializing";

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoadingAd = false;
  final adManager = AdManager();
  AdManager? _adHelper;
  String baseApiUrl = 'https://cognise.art/';
  late List<ItemModel> styles = [];
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _adHelper = AdManager(
      onAdLoading: () => setState(() => _isLoadingAd = true),
      onAdLoaded: () => setState(() => _isLoadingAd = false),
    );
    super.initState();
    setState(() {
      isGridLoading = true;
    });
    fetchData().then((_) {
      isGridLoading = false;
    });
    _textController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _updateTextFromArgs();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User reached the end of the list, fetch more data
      fetchData();
    }
  }

  void _handleTextChanges(String newText) {
    // Get the current cursor position
    final int cursorPosition = _textController.selection.baseOffset;

    setState(() {
      _textController.value = _textController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
            offset: cursorPosition.clamp(0, newText.length)),
      );
    });
  }

  Future<void> _sendImage() async {
    setState(() {
      isLoading = true;
    });
    updateLoadingText("Extracting Prompt..");
    final imageProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
    if (imageProvider.image == null) {
      // Handle the case where no image is selected
      return;
    }

    try {
      Img2Prompt img2Prompt = Img2Prompt();
      String caption =
          await img2Prompt.sendImage(imageProvider.image!, context);
      updateLoadingText("Almost Done..");
      setState(() {
        _caption = caption;
        if (_caption != null) {
          _textController.text = _caption!;
        }
      });
      setState(() {
        isLoading = false;
      });
      // Print the caption in the console
      print("Caption: $_caption");
    } catch (error) {
      // Handle the error
      print("Error: $error");
    }
    setState(() {
      isLoading = false;
    });
  }

  void _updateTextFromArgs() {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('prompt') && args['prompt'] != null) {
      _textController.text = args['prompt'];
    }
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Receive the route arguments here
  //   Map<String, dynamic>? args =
  //       ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

  //   // Check if 'prompt' key is present and not null
  //   if (args != null && args.containsKey('prompt') && args['prompt'] != null) {
  //     // Use the received prompt value to set the text in the TextField
  //     _textController.text = args['prompt'];
  //   }
  // }

  Future<void> fetchData() async {
    try {
      final apiService = StylesList();
      final fetchedItems = await apiService.fetchItems(context);

      setState(() {
        styles = fetchedItems;

        final firstItemWithOrder1 = styles.firstWhere((item) => item.order == 1,
            orElse: () => ItemModel(id: 0, imagePath: '', title: '', order: 0));
        _selectedStylesid = firstItemWithOrder1.id;
        print('initial styels id');
        print(_selectedStylesid);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // List<String> titles = [
  //   'Steampunk',
  //   'Cyberpunk',
  //   'Digital Painting',
  //   'B&W',
  //   'Picasso',
  //   'Concept Art',
  //   'Sci-Fi',
  //   'Anime',
  //   'Neon Colors',
  //   'Pop Art',
  //   'Low Poly',
  //   'Rembrandt',
  // ];

  int selectedIndex = 0;

  bool _isshowDialog = false;
  @override
  Widget build(BuildContext context) {
    // List<ItemModel> items = List.generate(
    //   12,
    //   (index) => ItemModel(
    //     imagePath: 'assets/images/ai_generator_images/ai_img$index.webp',
    //     title: titles[index % titles.length],
    //   ),
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            'text_to_image',
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
          width: 64,
          height: 24,
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Stack(children: [
              GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              localeText(context, 'describe_your_image'),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
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
                              child: TextField(
                                controller: _textController,
                                onChanged: _handleTextChanges,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.30,
                                ),
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: localeText(context, 'type_here'),
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteHelper.inspirationsPage,
                                  (route) =>
                                      route.settings.name ==
                                      RouteHelper.aiGenerator,
                                );
                              },
                              child: CustomButtonAi(
                                customImage: 'assets/icons/tips_icon.webp',
                                customText: localeText(context, 'inspirations'),
                                containerColor: Colors.white,
                                textColor: Colors.white,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  SettingModalBottomSheet()
                                      .showSettingModalBottomSheet(
                                    context,
                                    (samplingMethod, seeed, negativePrompt,
                                        slider, selectedSize) {
                                      // Handle the values received from the bottom sheet
                                      // You can use these values as needed in your AiGenerator screen
                                      // For example, update the state with these values
                                      setState(() {
                                        _negative = negativePrompt.text;
                                        _samplingMethod = samplingMethod;
                                        _seed = seeed.text;
                                        _slidervalue = slider;
                                        _selectedSize = selectedSize;
                                        print('---___________________----->' +
                                            '${samplingMethod}');
                                        // Do something with the values
                                      });
                                    },
                                  );
                                },
                                child: CustomButtonAi(
                                  customImage: 'assets/icons/add_white.webp',
                                  customText: localeText(
                                    context,
                                    'advance',
                                  ),
                                  containerColor: Colors.white,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final imageProvider =
                                    Provider.of<ImagePickerProvider>(context,
                                        listen: false);
                                bool imaagpeicke =
                                    await imageProvider.getImageFromGallery();

                                if (imaagpeicke) {
                                  _sendImage();
                                }
                              },
                              child: CustomButtonAi(
                                customImage: 'assets/icons/add_purple.webp',
                                customText: localeText(context, 'add_image'),
                                containerColor: const Color(0xFF8181FF),
                                textColor: const Color(0xFF8181FF),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              GlobalButton(
                                buttonText: localeText(
                                  context,
                                  'generate',
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    if (_textController.text.isEmpty) {
                                      ApiRequests apiRequests = ApiRequests();
                                      apiRequests.showErrorPopup(
                                          context,
                                          'Error',
                                          'Please enter a prompt before generating');
                                    } else {
                                      _isshowDialog = true;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              localeText(
                                context,
                                'select_style',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.36,
                              ),
                            ),
                            Expanded(child: Container()),
                            // const Text(
                            //   'See All',
                            //   style: TextStyle(
                            //     color: Color.fromARGB(255, 139, 139, 139),
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w600,
                            //     letterSpacing: 0.36,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 800,
                          width: double.infinity,
                          child: GridView.builder(
                              controller: _scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: MediaQuery.of(context)
                                        .size
                                        .width ~/
                                    110, // Adjust the item width based on the screen size
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 0,
                              ),
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                if (index >= 0 && index < styles.length) {
                                  ItemModel item = styles[index];
                                  bool isSelected = selectedIndex == index;

                                  return GestureDetector(
                                      onTap: () {
                                        if (!isSelected) {
                                          setState(() {
                                            selectedIndex =
                                                isSelected ? -1 : index;
                                            _selectedStylesid =
                                                isSelected ? 1 : item.id;
                                            print(
                                                'styles after selecting selected_id' +
                                                    '{$_selectedStylesid}');
                                          });
                                        }
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 110,
                                              height: 154,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF8181FF)
                                                        : Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              '${baseApiUrl}/${item.imagePath}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/icons/loading.png')),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          fit: BoxFit.cover,
                                                          height: 152,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (isSelected)
                                                    const Positioned.fill(
                                                      child: Center(
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/icons/checkmarkRounded.webp'),
                                                          width: 25,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  Positioned(
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: FittedBox(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          10))),
                                                          height: 30,
                                                          width: 150,
                                                          child: Center(
                                                            child: Text(
                                                              item.title,
                                                              style: TextStyle(
                                                                color: isSelected
                                                                    ? const Color(
                                                                        0xFF8181FF)
                                                                    : Colors
                                                                        .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0.80,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines:
                                                                  1, // Set the maximum number of lines
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ]));
                                } else {
                                  Container(
                                    child: const Text(
                                      'List empty',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  );
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isshowDialog)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Colors.black.withOpacity(0.8),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: GeneratingArtwork(
                        watchVideoCallback: () async {
                          _adHelper!.createRewardedAd();
                          adManager.showRewardedAd(context, () async {
                            ApiRequests apiRequests = ApiRequests();
                            setState(() {
                              isLoading = true;
                              _isshowDialog = false;
                            });
                            await apiRequests.sendRequest(
                                context,
                                _textController,
                                _samplingMethod,
                                _negative,
                                _seed,
                                _slidervalue,
                                _selectedStylesid,
                                _selectedSize,
                                updateLoadingText);
                            print('===========>' + '${_samplingMethod}');
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          });
                        },
                        premiumCallback: () {},
                      ),
                    ),
                  ),
                ),
              if (isGridLoading)
                const SpinKitSpinningLines(color: Color(0xFF8181FF)),
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
                        ))),
              if (_isLoadingAd) const Center(child: AdLoading())
            ]),
          ),
          if (!_isshowDialog)
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
              ),
            ),
        ]),
      ),
    );
  }

  void updateLoadingText(String statusText) {
    setState(() {
      loadingText =
          statusText; // 'loadingText' is a String variable that holds the current loading text.
    });
  }
}

// class ItemModel {
//   final String imagePath;
//   final String title;

//   ItemModel({required this.imagePath, required this.title});
// }
