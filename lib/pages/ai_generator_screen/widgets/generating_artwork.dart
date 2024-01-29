import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:provider/provider.dart';

class GeneratingArtwork extends StatelessWidget {
  const GeneratingArtwork(
      {super.key,
      required this.watchVideoCallback,
      required this.premiumCallback});
  final VoidCallback watchVideoCallback;
  final VoidCallback premiumCallback;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<LocalizationProvider>(builder:
          (BuildContext context, LocalizationProvider value, Widget? child) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: 40, vertical: value.checkIsArOrUr() ? 120 : 150),
          decoration: ShapeDecoration(
            color: const Color(0xFF1E1E1E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Column(children: [
            const Image(
              image: AssetImage('assets/images/generatingart.webp'),
              width: 277,
              height: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              localeText(
                context,
                'generate_artwork',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              localeText(
                context,
                'to_create_an_image_use_this_prompt',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              localeText(context, 'choose_one_of_the_options_below'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: watchVideoCallback,
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-1.00, 0.00),
                          end: Alignment(1, 0),
                          colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 9),
                            child: Image(
                              width: 30,
                              image: AssetImage('assets/icons/video_icon.webp'),
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localeText(
                                    context,
                                    'watch_video',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    localeText(
                                        context, 'this_action_may_contain_ads'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 6.5,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -0.28,
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF8181FF)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 13),
                              child: Image(
                                image: AssetImage(
                                    'assets/icons/premium_icon.webp'),
                                width: 20,
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localeText(
                                      context,
                                      'premium',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.12,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      localeText(
                                        context,
                                        'premium_purchase_needed',
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 6.5,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
