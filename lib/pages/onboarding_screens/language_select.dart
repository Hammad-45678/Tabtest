import 'package:flutter/material.dart';
import 'package:picstar/pages/home_screen/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../global/widgets/ad_manager.dart';
import '../../global/widgets/ad_widget.dart';
import '../../global/widgets/adloading.dart';
import '../../translation_manager/language_constants.dart';
import '../../translation_manager/localization_provider.dart';
import '../../translation_manager/translations.dart';

class LanguageSelect extends StatefulWidget {
  const LanguageSelect({super.key});

  @override
  State<LanguageSelect> createState() => _LanguageSelectState();
}

String selectedLanguage = "";
bool _isLoadingAd = false;
final adManager = AdManager();
AdManager? _adHelper;

class _LanguageSelectState extends State<LanguageSelect> {
  @override
  void initState() {
    adManager.createInterstitialAd();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------------------------------> build Called');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(children: [
            Row(children: [
              const Expanded(
                child: Text(
                  'Choose your preferred language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    height: 0,
                    letterSpacing: 3.60,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  adManager.createInterstitialAd();
                  adManager.showInterstitialAd();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const home_page()),
                  ).then((value) => Navigator.pop(context));
                },
                child: Container(
                  width: 70,
                  height: 32,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1.00, 0.00),
                      end: Alignment(1, 0),
                      colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Center(
                    child: Text(
                      'done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Image.asset('assets/icons/divider.webp'),
          ]),
        ),
        body: Stack(children: [
          Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: Languages.languages.length,
                itemBuilder: (context, index) {
                  Languages lang = Languages.languages[index];
                  final isSelected = context
                          .read<LocalizationProvider>()
                          .locale
                          .languageCode ==
                      lang.languageCode;
                  return Consumer<LocalizationProvider>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          context.read<LocalizationProvider>().setLocale(lang);
                          setState(() {
                            selectedLanguage = lang.toString();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                            gradient: isSelected
                                ? const LinearGradient(
                                    begin: Alignment(-1.00, 0.00),
                                    end: Alignment(1, 0),
                                    colors: [
                                      Color(0xFF8181FF),
                                      Color(0xFFC74EC8)
                                    ],
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 11, left: 10, bottom: 10, right: 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localeText(context, lang.name),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                        letterSpacing: 0.60,
                                      ),
                                    ),
                                    Text(
                                      lang.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                child: Image.asset(
                                  value.locale.languageCode == lang.languageCode
                                      ? 'assets/icons/radio_checked.webp'
                                      : 'assets/icons/radio_unchecked.webp',
                                  height: 15,
                                  width: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
          if (_isLoadingAd)
            const Align(alignment: Alignment.center, child: AdLoading()),
        ]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Adjust the radius here
            color: Colors.white, // Optional: Set background color
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10), // Match the radius with the Container
            child: const NativeAdWidget(),
          ),
        ),
      ),
    );
  }
}
