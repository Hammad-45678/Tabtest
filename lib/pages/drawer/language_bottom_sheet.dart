import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../translation_manager/language_constants.dart';
import '../../translation_manager/localization_provider.dart';
import '../../translation_manager/translations.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LanguageBottomSheetState createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String selectedLanguage = "";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 22 : 16;
    double langfontSize = screenWidth > 600 ? 19 : 15;
    double langnamefontSize = screenWidth > 600 ? 15 : 10;
    return Container(
        height: 500,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color(0xFF222222),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[600],
              ),
              height: 5,
              width: 50,
            ),
          ),
          ListTile(
            title: Text(
              localeText(
                context,
                'app_language',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.48,
              ),
            ),
            trailing: Consumer<LocalizationProvider>(
                builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
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
                  child: Center(
                    child: Text(
                      localeText(
                        context,
                        'done',
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Image.asset('assets/icons/divider.webp'),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, top: 18, bottom: 8),
          //   child: Text(
          //     localeText(
          //       context,
          //       'current_language',
          //     ),
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w400,
          //       height: 0,
          //     ),
          //   ),
          // ),
          // Container(
          //   width: double.infinity,
          //   margin: const EdgeInsets.symmetric(horizontal: 20),
          //   height: 50,
          //   decoration: ShapeDecoration(
          //     gradient: const LinearGradient(
          //       begin: Alignment(-1.00, 0.00),
          //       end: Alignment(1, 0),
          //       colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //   ),
          //   child: ListTile(
          //     title: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             selectedLanguage,
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 12,
          //               fontWeight: FontWeight.w600,
          //               letterSpacing: 0.60,
          //             ),
          //           ),
          //           Text(
          //             selectedLanguage,
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 8,
          //               fontWeight: FontWeight.w600,
          //               letterSpacing: 0.30,
          //             ),
          //           ),
          //         ]),
          //     trailing: const Padding(
          //       padding: EdgeInsets.only(top: 5),
          //       child: Column(
          //         children: [
          //           Icon(
          //             Icons.radio_button_checked,
          //             color: Colors.white,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 18),
            child: Text(
              'All Language',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Languages.languages.length,
              itemBuilder: (context, index) {
                Languages lang = Languages.languages[index];
                final isSelected =
                    context.read<LocalizationProvider>().locale.languageCode ==
                        lang.languageCode;
                return InkWell(
                  onTap: () {
                    setState(() {
                      context.read<LocalizationProvider>().setLocale(lang);
                      selectedLanguage = localeText(context, lang.name);
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment(-1.00, 0.00),
                              end: Alignment(1, 0),
                              colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 11, left: 10, bottom: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localeText(context, lang.name),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: langfontSize,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: 0.60,
                                ),
                              ),
                              Text(
                                lang.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: langnamefontSize,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<LocalizationProvider>(
                          builder: (context, value, child) {
                            return Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                child: Image.asset(
                                  value.locale.languageCode == lang.languageCode
                                      ? 'assets/icons/radio_checked.webp' // Path to the checked image
                                      : 'assets/icons/radio_unchecked.webp', // Path to the outline image
                                  height: 15,
                                  width: 15,
                                  color: Colors.white,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
