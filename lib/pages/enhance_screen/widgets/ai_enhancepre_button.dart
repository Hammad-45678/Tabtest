import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';

class ai_enhance_pre_button extends StatelessWidget {
  final String buttonText;
  final double buttonheight;
  final double buttonTextFontSize;
  final double descriptionTextFontSize;
  final double iconwidth;
  final double iconheight;
  final double buttonwidth;
  const ai_enhance_pre_button({
    super.key,
    required this.buttonText,
    this.buttonheight = 45,
    this.buttonTextFontSize = 16,
    this.descriptionTextFontSize = 9,
    this.iconwidth = 27,
    this.iconheight = 27,
    this.buttonwidth = 292,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        width: buttonwidth,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF8181FF)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
              child: Image(
                image: const AssetImage('assets/icons/premium_icon.webp'),
                width: iconwidth,
                height: iconheight,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: const Color(0xFF8181FF),
                      fontSize: buttonTextFontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    localeText(context, 'get_all_features_unlocked'),
                    style: TextStyle(
                      color: const Color(0xFF8181FF),
                      fontSize: descriptionTextFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            const SizedBox(
              height: 27,
              width: 27,
            )
          ],
        ),
      ),
    );
  }
}
