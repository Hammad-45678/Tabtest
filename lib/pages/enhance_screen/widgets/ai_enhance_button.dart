import 'package:flutter/material.dart';

class CustomEnhanceButton extends StatelessWidget {
  final String buttonText;
  final String descriptionText;
  final String imagePath;
  final double height;
  final double width;
  final double buttonTextFontSize;
  final double descriptionTextFontSize;
  final double iconwidth;
  final double iconheight;
  const CustomEnhanceButton({
    Key? key,
    required this.buttonText,
    required this.descriptionText,
    required this.imagePath,
    this.height = 27,
    this.width = 27,
    this.iconheight = 27,
    this.iconwidth = 27,
    this.buttonTextFontSize = 16.0,
    this.descriptionTextFontSize = 9.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.00, 0.00),
          end: Alignment(1, 0),
          colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            child: Image(
              image: AssetImage(
                imagePath,
              ),
              width: iconwidth,
              height: iconheight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonTextFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  descriptionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: descriptionTextFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 27,
            height: 27,
          ),
        ],
      ),
    );
  }
}
